//
//  EntryView.swift
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct EntryView: View {
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack(spacing: 70.getWidth()) {
                    Image("Kimo")
                        .resizable()
                        .scaledToFit()
                        .kimoImageAccessibility(
                            label: "Kimo, karakter utama aplikasi",
                            isDecorative: false,
                            identifier: "entry.kimoCharacter"
                        )
                        .frame(width: 400.getWidth())
                    
                    VStack(alignment: .leading) {
                        Text("Hai, aku Kimo!")
                            .font(.app(.largeTitle, family: .primary))
                            .kimoTextGroupAccessibility(
                                combinedLabel: "Hai, aku Kimo!",
                                identifier: "entry.welcomeMessage",
                                sortPriority: 1
                            )

                        Text("Di sini, kamu dan si kecil akan belajar mengenal perasaan lewat cerita dan permainan seru.")
                            .font(.app(.body, family: .primary))
                            .padding(.bottom, 40.getHeight())
                            .kimoTextGroupAccessibility(
                                combinedLabel: "Di sini, kamu dan si kecil akan belajar mengenal perasaan lewat cerita dan permainan seru.",
                                identifier: "entry.welcomeMessageTwo",
                                sortPriority: 2
                            )
                        
                        NavigationLink {
                            IdentityView()
                        } label: {
                            KimoBubbleButton(buttonLabel: "Ayo Mulai!")
                        }
                    }
                    
                }
                .padding(.horizontal, 110.getWidth())
                
                Spacer()
            }
        }
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Selamat datang di aplikasi Kimo. Halaman pembuka siap digunakan.")
            }
        }
    }
}

#Preview {
    EntryView()
}
