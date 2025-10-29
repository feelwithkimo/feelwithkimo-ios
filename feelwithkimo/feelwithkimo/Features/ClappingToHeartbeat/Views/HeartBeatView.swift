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
    @StateObject private var viewModel: HeartbeatViewModel
    
    init(bpm: Double, isClapping: Binding<Bool>, onBeat: (() -> Void)? = nil) {
        _isClapping = isClapping
        _viewModel = StateObject(wrappedValue: HeartbeatViewModel(bpm: bpm, onBeat: onBeat))
    }
    
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
            .foregroundStyle(.red)
            .scaleEffect(viewModel.isExpanded ? 1.35 : 1.0)
            .shadow(color: .red.opacity(0.6), radius: viewModel.isExpanded ? 25 : 5)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isExpanded)
            .onAppear {
                viewModel.start()
            }
            .onDisappear {
                viewModel.stop()
            }
            .onChange(of: isClapping) { newValue, _ in
                viewModel.updateClapState(isClapping: newValue)
            }
    }
}
