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
                
                HStack(spacing: 70) {
                    Image("Kimo")
                        .resizable()
                        .scaledToFit()
                        .kimoImageAccessibility(
                            label: "Kimo, karakter utama aplikasi",
                            isDecorative: false,
                            identifier: "entry.kimoCharacter"
                        )
                        .frame(width: 400 / 1194 * UIScreen.main.bounds.width)
                    
                    VStack(alignment: .leading) {
                        Text("Hai, aku Kimo!")
                            .font(.app(.largeTitle, family: .primary))
                            .fontWeight(.bold)
                            .kimoTextGroupAccessibility(
                                combinedLabel: "Hai, aku Kimo!",
                                identifier: "entry.welcomeMessage",
                                sortPriority: 1
                            )

                        Text("Di sini, kamu dan si kecil akan belajar mengenal perasaan lewat cerita dan permainan seru.")
                            .font(.app(.body, family: .primary))
                            .fontWeight(.regular)
                            .padding(.bottom, 50)
                            .kimoTextGroupAccessibility(
                                combinedLabel: "Di sini, kamu dan si kecil akan belajar mengenal perasaan lewat cerita dan permainan seru.",
                                identifier: "entry.welcomeMessageTwo",
                                sortPriority: 2
                            )
                        
                        NavigationLink {
                            IdentityView()
                        } label: {
                            KimoButton(textLabel: "Ayo Mulai!")
                        }
                        .kimoNavigationAccessibility(
                            label: "Ayo Mulai",
                            hint: "Ketuk dua kali untuk mulai menggunakan aplikasi dan mengisi identitas",
                            identifier: "entry.startButton"
                        )
                    }
                    
                }
                .padding(.horizontal, 110)
                
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
