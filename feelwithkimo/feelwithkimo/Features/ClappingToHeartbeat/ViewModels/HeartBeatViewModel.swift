//
//  HeartBeatViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 26/10/25.
//

import SwiftUI
import Combine

final class HeartbeatViewModel: ObservableObject {
    @Published var isExpanded = false
    @Published var lastClapTime: Date?
    
    private let bpm: Double
    private let tolerance: Double = 0.3
    private var timer: AnyCancellable?
    private var onBeat: (() -> Void)?
    
    init(bpm: Double, onBeat: (() -> Void)? = nil) {
        self.bpm = bpm
        self.onBeat = onBeat
    }
    
    func start() {
        let interval = 60.0 / bpm
        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] tick in
                self?.handleTick(tick)
            }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    func updateClapState(isClapping: Bool) {
        if isClapping {
            lastClapTime = Date()
        }
    }
    
    private func handleTick(_ tick: Date) {
        guard let clapTime = lastClapTime else {
            relaxBeat()
            return
        }

        let delta = abs(clapTime.timeIntervalSince(tick))
        if delta < tolerance {
            triggerBeat()
        } else {
            relaxBeat()
        }
    }
    
    private func triggerBeat() {
        onBeat?()
        withAnimation(.easeInOut(duration: 0.2)) {
            isExpanded = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.2)) {
                self.isExpanded = false
            }
        }
    }
    
    private func relaxBeat() {
        withAnimation(.easeOut(duration: 0.2)) {
            isExpanded = false
        }
    }
}
