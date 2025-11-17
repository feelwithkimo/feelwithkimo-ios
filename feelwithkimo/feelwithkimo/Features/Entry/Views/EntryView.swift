//
//  EntryView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct EntryView: View {
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    mainBackgroundView(geometry: geometry)
                    
                    mainEntryView(geometry: geometry)
                }
            }
        }
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Selamat datang di aplikasi Kimo. Halaman pembuka siap digunakan.")
            }
        }
        .dynamicTypeSize(.xSmall ... .large)
    }
    
    private func mainEntryView(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                
                Text("Hai, aku")
                    .font(.customFont(size: 34, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .padding(.bottom, geometry.size.height * 0.01)
                
                KimoImage(image: "Kimo-Pink-Wave", width: geometry.size.width * 0.51)
                
                Text("Aku akan menemani kamu dan si kecil belajar mengenal perasaan lewat cerita dan permainan seru.")
                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .frame(maxWidth: 356.getWidth())
                    .multilineTextAlignment(.trailing)
                    .padding(.top, geometry.size.height * 0.006)
                
                NavigationLink {
                    OldEmotionStoryView(viewModel: EmotionStoryViewModel(path: "Balok"))
                } label: {
                    KimoBubbleButtonPrimary(buttonLabel: "Ayo Mulai")
                }
                .padding(.top, geometry.size.height * 0.084)
                
                Spacer()
            }
            .padding(.trailing, geometry.size.width * 0.067)
            .offset(y: -geometry.size.height * 0.096)
        }
    }
    
    private func mainBackgroundView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottomLeading) {
            KimoEllipseView()
                .offset(y: geometry.size.height * 0.675)
            
            Image("KimoDefault")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.587, height: geometry.size.height * 0.687)
                .offset(x: geometry.size.width * 0.042, y: geometry.size.height * 0.055)
        }
    }
}

#Preview {
    EntryView()
}
