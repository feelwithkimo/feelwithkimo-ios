//
//  ClapGameViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import Foundation
import Combine
import AVFoundation

enum HandState {
    case noHand, oneHand, twoHands
}

@MainActor
final class ClapGameViewModel: ObservableObject {
    // MARK: - Published Properties (State untuk UI)
    @Published private(set) var user1Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil)
    @Published private(set) var user2Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil)
    @Published private(set) var beatCount: Int = 0
    @Published private(set) var isHeartbeatActive: Bool = false
    @Published private(set) var didClapSuccessfully: Bool = false
    @Published private(set) var showClapFeedback: Bool = false

    // Properti komputasi untuk View agar lebih bersih
    var user1HandState: HandState { detectHandState(for: user1Hands) }
    var user2HandState: HandState { detectHandState(for: user2Hands) }
    var avSession: AVCaptureSession { visionManager.session }

    // MARK: - Private Properties
    private let visionManager = VisionManager()
    private let heartBeatManager = HeartBeatManager()
    private let clapUser1 = ClapViewModel()
    private let clapUser2 = ClapViewModel()

    private var cancellables = Set<AnyCancellable>()
    private let syncTolerance: TimeInterval = 0.5

    // MARK: - Callback
    private var onCompletion: (() -> Void)?

    init(onCompletion: (() -> Void)? = nil) {
        self.onCompletion = onCompletion
        setupSubscriptions()
    }

    // MARK: - Public Methods (Intent dari View)
    func startHeartbeat() {
        heartBeatManager.playLoopedSound(named: "heartbeat_100bpm")
        isHeartbeatActive = true
    }

    func stopHeartbeat() {
        heartBeatManager.stopSound()
        isHeartbeatActive = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.onCompletion?()
        }
    }

    func onHeartbeat() {
        if beatCount < 4 {
            beatCount += 1
            print("Beat count: \(beatCount)")
        } else {
            stopHeartbeat()
        }
    }

    // MARK: - Private Logic
    private func setupSubscriptions() {
        // Mengamati posisi tangan dari VisionManager
        visionManager.$user1Hands
            .assign(to: &$user1Hands)

        visionManager.$user2Hands
            .assign(to: &$user2Hands)

        // Mengamati tepukan dari setiap user
        clapUser1.observeHands(
            $user1Hands
                .map { ($0.left, $0.right) }
                .eraseToAnyPublisher()
        )
        clapUser2.observeHands(
            $user2Hands
                .map { ($0.left, $0.right) }
                .eraseToAnyPublisher()
        )

        // Mengamati kapan kedua user bertepuk tangan bersamaan
        Publishers.CombineLatest(clapUser1.$lastClapTime, clapUser2.$lastClapTime)
            .sink { [weak self] time1, time2 in
                guard let self = self, let time1 = time1, let time2 = time2 else { return }

                if abs(time1.timeIntervalSince(time2)) < self.syncTolerance {
                    self.triggerBothClap()
                }
            }
            .store(in: &cancellables)
    }

    private func triggerBothClap() {
        guard !showClapFeedback else { return }

        didClapSuccessfully.toggle() // Ganti warna
        showClapFeedback = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.showClapFeedback = false
        }
    }

    private func detectHandState(for hands: (left: CGPoint?, right: CGPoint?)) -> HandState {
        switch (hands.left, hands.right) {
        case (nil, nil):
            return .noHand
        case (.some, .none), (.none, .some):
            return .oneHand
        default:
            return .twoHands
        }
    }
}
