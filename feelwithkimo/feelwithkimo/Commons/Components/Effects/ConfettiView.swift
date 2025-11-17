//
//  ConfettiView.swift
//  feelwithkimo
//
//  Created by Aristo Yongka on 17/11/25.
//

import SwiftUI
import Lottie

struct ConfettiView: View {
    var body: some View {
        LottieView(animation: .named("Confetti.lottie"))
            .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
    }
}

#Preview {
    ConfettiView()
}
