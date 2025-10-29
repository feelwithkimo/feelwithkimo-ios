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
                Image("Kimo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330)
                    .padding(.bottom, 70)
                    .kimoImageAccessibility(
                        label: "Kimo, karakter utama aplikasi",
                        isDecorative: false,
                        identifier: "entry.kimoCharacter"
                    )

                // Combined text container for better VoiceOver experience
                VStack(spacing: 16) {
                    Text("Hai, aku Kimo!")
                        .font(.app(.largeTitle, family: .primary))
                        .fontWeight(.bold)

                    Text("Yuk, bantu si kecil mengenal perasaan dengan cerita dan permainan seru")
                        .font(.app(.title2, family: .primary))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
                        .padding(.horizontal)
                }
                .padding(.bottom, 35)
                .kimoTextGroupAccessibility(
                    combinedLabel: "Hai, aku Kimo! Yuk, bantu si kecil mengenal perasaan dengan cerita dan permainan seru",
                    identifier: "entry.welcomeMessage",
                    sortPriority: 1
                )

                NavigationLink {
                    IdentityView()
                } label: {
                    KimoButton(textLabel: "Ayo Mulai")
                }
                .kimoNavigationAccessibility(
                    label: "Ayo Mulai",
                    hint: "Ketuk dua kali untuk mulai menggunakan aplikasi dan mengisi identitas",
                    identifier: "entry.startButton"
                )
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
