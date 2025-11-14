//
//  CompletionPageView.swift
//  feelwithkimo
//
//  Created on 14/11/25.
//

import SwiftUI

struct CompletionPageView: View {
    var title: String = "Tahap 1 Selesai!!!"
    var primaryButtonLabel: String = "Coba lagi"
    var secondaryButtonLabel: String = "Lanjutkan"
    var onPrimaryAction: (() -> Void)?
    var onSecondaryAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Background image
            Image("Scene 17")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Black overlay with 70% opacity
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Completion card
            CompletionCardView(
                title: title,
                elephantImage: "KimoSenang",
                primaryButtonLabel: primaryButtonLabel,
                secondaryButtonLabel: secondaryButtonLabel,
                onPrimaryAction: onPrimaryAction,
                onSecondaryAction: onSecondaryAction
            )
        }
    }
}

#Preview {
    CompletionPageView()
}
