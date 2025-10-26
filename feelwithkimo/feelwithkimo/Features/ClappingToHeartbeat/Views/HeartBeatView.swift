//
//  HeartBeatView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import Combine
import SwiftUI

struct HeartbeatView: View {
    @Binding var isClapping: Bool
    var bpm: Double
    var onBeat: (() -> Void)?
    
    private let tolerance: Double = 0.3
    @State private var lastClapTime: Date?
    @State private var isExpanded = false
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    // MARK: - Init
    init(bpm: Double, isClapping: Binding<Bool>, onBeat: (() -> Void)? = nil) {
        self._isClapping = isClapping
        self.bpm = bpm
        self.onBeat = onBeat
    }

    // MARK: - Body
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundColor(.red)
            .scaleEffect(isExpanded ? 1.35 : 1.0)
            .shadow(color: .red.opacity(0.6), radius: isExpanded ? 25 : 5)
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
            .onAppear(perform: setupTimer)
            .onChange(of: isClapping) { newValue, _ in
                if newValue { lastClapTime = Date() }
            }
            .onReceive(timer ?? Timer.publish(every: 60 / bpm, on: .main, in: .common).autoconnect()) { tick in
                handleTick(tick)
            }
    }

    // MARK: - Private Methods
    private func setupTimer() {
        let interval = 60.0 / bpm
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
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
        withAnimation(.easeInOut(duration: 0.2)) { isExpanded = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.2)) { isExpanded = false }
        }
    }

    private func relaxBeat() {
        withAnimation(.easeOut(duration: 0.2)) { isExpanded = false }
    }
}
