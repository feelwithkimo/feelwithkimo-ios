//
//  NewEntryView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct NewEntryView: View {
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
                    .font(.app(.largeTitle, family: .primary))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .padding(.bottom, geometry.size.height * 0.01)
                
                Image("Kimo-Pink-Wave")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.51)
                
                Text("Aku akan menemani kamu dan si kecil belajar mengenal perasaan lewat cerita dan permainan seru.")
                    .font(.app(.title1, family: .primary))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .frame(maxWidth: geometry.size.width * 0.32)
                    .multilineTextAlignment(.trailing)
                    .padding(.top, geometry.size.height * 0.006)
                
                NavigationLink {
                    IdentityView()
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
            Ellipse()
                .trim(from: 0.5, to: 1)
                .fill(ColorToken.backgroundEntry.toColor().opacity(0.5))
                .frame(width: geometry.size.width, height: geometry.size.height * 0.74)
                .offset(y: geometry.size.height * 0.55)
            
            Image("KimoDefault")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.587, height: geometry.size.height * 0.687)
                .offset(x: geometry.size.width * 0.042, y: geometry.size.height * 0.18)
        }
    }
}

#Preview {
    NewEntryView()
}
