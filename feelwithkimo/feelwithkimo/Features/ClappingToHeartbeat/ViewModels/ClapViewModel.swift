//
//  ClapViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import Combine
import CoreGraphics
import Foundation

final class ClapViewModel: ObservableObject {
    @Published var isClapping = false
    @Published var lastClapTime: Date?

    private var cancellables = Set<AnyCancellable>()
    private let clapThreshold: CGFloat = 0.12
    private let deltaThreshold: CGFloat = 0.03
    private var history: [CGFloat] = []
    private let maxHistory = 5

    /// Deteksi tepuk tangan berdasarkan jarak antar tangan
    func observeHands(_ publisher: AnyPublisher<(CGPoint?, CGPoint?), Never>) {
        publisher
            .compactMap { leftOpt, rightOpt in
                guard let left = leftOpt, let right = rightOpt else { return nil }
                return (left, right)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] left, right in
                self?.detectClap(left: left, right: right)
            }
            .store(in: &cancellables)
    }

    private func detectClap(left: CGPoint, right: CGPoint) {
        let xDifference = left.x - right.x
        let yDifference = left.y - right.y
        let dist = sqrt(xDifference*xDifference + yDifference*yDifference)

        history.append(dist)
        if history.count > maxHistory { history.removeFirst() }

        let avg = history.reduce(0, +) / CGFloat(history.count)
        let delta = avg - dist

        if dist < clapThreshold && delta > deltaThreshold {
            triggerClap()
        }
    }

    private func triggerClap() {
        guard !isClapping else { return }
        isClapping = true
        lastClapTime = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isClapping = false
        }
    }
}
