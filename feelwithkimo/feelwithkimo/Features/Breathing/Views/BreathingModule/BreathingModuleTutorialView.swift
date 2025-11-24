//
//  BreathingModuleTutorialView.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 21/11/25.
//

import SwiftUI

struct BreathingModuleTutorialView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            VStack(spacing: 40) {
                Text("Ketuk bagian mana pun di layar untuk lanjut.")
                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                    .foregroundStyle(Color.white)
                Spacer()
                VStack {
                    Text("Cara latihan pernafasan")
                        .font(.customFont(size: 34, family: .primary, weight: .bold))
                        .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    VStack(spacing: 25){
                        HStack(spacing: 25) {
                            KimoBreathingTutorialCard(
                                kimoBreathingMode: .inhale)
                            CustomChevron()
                            KimoBreathingTutorialCard(
                                kimoBreathingMode: .hold
                            )
                            CustomChevron()
                            KimoBreathingTutorialCard(
                                kimoBreathingMode: .exhale
                            )
                        }
                        (Text(
                            "Menurut Dokter Weil, ")
                            .font(.customFont(size: 17, family: .primary, weight: .bold))
                         +
                         Text("latihan pernapasan ini membantu menenangkan sistem saraf secara alami. Semakin rutin dilakukan, semakin mudah anak mengatur rasa cemas dan menenangkan tubuhnya.")
                            .font(.customFont(size: 17, family: .primary, weight: .regular)))
                        .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                        .lineLimit(3)
                        .frame(width: 604.getWidth())
                        .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 38)
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(30)
                Spacer()
            }
            .padding(.vertical, 60)
        }
        .frame(width: .infinity, height: .infinity)
        .ignoresSafeArea()
    }
}

struct KimoBreathingTutorialCard: View {
    let kimoBreathingMode: BreathingPhase

    var title: String {
        switch kimoBreathingMode {
        case .inhale: "Tarik Nafas"
        case .hold: "Tahan Nafas"
        case .exhale: "Hembus Nafas"
        }
    }
    
    var duration: String {
        switch kimoBreathingMode {
        case .inhale:
            "4 detik"
        case .hold:
            "3 detik"
        case .exhale:
            "1 detik"
        }
    }
    
    var imageName: String {
        switch kimoBreathingMode {
        case .inhale:
            "Kimo-Inhale"
        case .hold:
            "Kimo-Hold-Breath"
        case .exhale:
            "Kimo-Exhale"
        }
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.customFont(size: 22, family: .primary, weight: .bold))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
            Text(duration)
                .font(.customFont(size: 15, family: .primary, weight: .regular))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
            ZStack {
                Ellipse()
                    .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                    .frame(width: 100.getWidth(), height: 20.getHeight())
                    .padding(.top, 108.getHeight())
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 92.getWidth(), height: 118.getHeight())
                    .padding(.leading, 15.getWidth())
            }
        }
    }
}

struct CustomChevron: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                .frame(width: 50.getWidth(), height: 50.getHeight())
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                .frame(width: 14.getWidth(), height: 23.getHeight())
        }
    }
}

#Preview {
    BreathingModuleTutorialView()
}
