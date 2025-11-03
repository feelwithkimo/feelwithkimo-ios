//
//  ClapGameViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import AVFoundation
import Combine
import Foundation

enum HandState {
    case noHand, oneHand, twoHands
}

@MainActor
final class ClapGameViewModel: ObservableObject {
    // MARK: - Published Properties (State untuk UI)
    @Published private(set) var user1Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil) {
        didSet {
            let newState = detectHandState(for: user1Hands)
            if newState == .twoHands, !hasAnnouncedTwoHandsUser1 {
                hasAnnouncedTwoHandsUser1 = true
                ClappingAccessibilityManager.announceHandDetection(handState: newState)
            }
        }
    }

    @Published private(set) var user2Hands: (left: CGPoint?, right: CGPoint?) = (nil, nil) {
        didSet {
            let newState = detectHandState(for: user2Hands)
            if newState == .twoHands, !hasAnnouncedTwoHandsUser2 {
                hasAnnouncedTwoHandsUser2 = true
                ClappingAccessibilityManager.announceHandDetection(handState: newState)
            }
        }
    }
    @Published private(set) var beatCount: Int = 0 {
        didSet {
            if beatCount > 0 {
                ClappingAccessibilityManager.announceGameProgress(currentStep: beatCount)
            }
        }
    }
    @Published private(set) var didClapSuccessfully: Bool = false
    @Published private(set) var showClapFeedback: Bool = false {
        didSet {
            if showClapFeedback {
                ClappingAccessibilityManager.announceClapFeedback(isSuccessful: didClapSuccessfully)
            }
        }
    }

    // Properti komputasi untuk View agar lebih bersih
    var user1HandState: HandState { detectHandState(for: user1Hands) }
    var user2HandState: HandState { detectHandState(for: user2Hands) }
    var avSession: AVCaptureSession { visionManager.session }
    let totalClap = 20

    // MARK: - Private Properties
    private let visionManager = VisionManager()
    private let accessibilityManager: AccessibilityManager
    private let clapUser1 = ClapViewModel()
    private let clapUser2 = ClapViewModel()

    private var cancellables = Set<AnyCancellable>()
    private var hasAnnouncedTwoHandsUser1 = false
    private var hasAnnouncedTwoHandsUser2 = false
    private let syncTolerance: TimeInterval = 0.5

    // MARK: - Callback
    private var onCompletion: (() -> Void)?

    init(onCompletion: (() -> Void)? = nil, accessibilityManager: AccessibilityManager) {
        self.onCompletion = onCompletion
        self.accessibilityManager = accessibilityManager
        setupSubscriptions()
    }
    
    func announceGameStart() {
        accessibilityManager.announceScreenChange(
            "Permainan tepuk tangan dimulai! Ayo posisikan tangan di depan kamera, dan tepuklah bersama dengan penuh semangat dan keceriaan."
        )
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
        Publishers.CombineLatest(clapUser1.$isClapping, clapUser2.$isClapping)
                    .sink { [weak self] isClapping1, isClapping2 in
                        guard let self = self else { return }
                        if isClapping1 || isClapping2 {
                            self.triggerBothClap()
                        }
                    }
                    .store(in: &cancellables)
    }

    private func triggerBothClap() {
        guard !showClapFeedback else { return }

        didClapSuccessfully.toggle()
        showClapFeedback = true
        if beatCount < totalClap {
            beatCount += 1
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.onCompletion?()
            }
        }
        
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
