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
                Text(NSLocalizedString("TapAnywhere", comment: ""))
                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                VStack {
                    Text(NSLocalizedString("BreathingTutorialTitle", comment: ""))
                        .font(.customFont(size: 34, family: .primary, weight: .bold))
                        .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    
                    VStack(spacing: 25) {
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
                            NSLocalizedString("BreathingTutorialReference", comment: ""))
                            .font(.customFont(size: 17, family: .primary, weight: .bold))
                         +
                         Text(NSLocalizedString("BreathingTutorialBody", comment: ""))
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
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(ColorToken.corePinkDialogue.toColor(), lineWidth: 5)
                )
                .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.25), radius: 18.3, x: 4, y: 4)
                Spacer()
            }
            .padding(.vertical, 60)
        }
        .ignoresSafeArea()
    }
}

struct KimoBreathingTutorialCard: View {
    let kimoBreathingMode: BreathingPhase

    var title: String {
        kimoBreathingMode.localizedText
    }
    
    var duration: String {
        return "\(Int(kimoBreathingMode.duration)) " + NSLocalizedString("Second", comment: "")
    }
    
    var imageName: String {
        kimoBreathingMode.imageName
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.customFont(size: 22, family: .primary, weight: .bold))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                .fixedSize(horizontal: true, vertical: false)
            Text(duration)
                .font(.customFont(size: 15, family: .primary, weight: .regular))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                .fixedSize(horizontal: true, vertical: false)
            ZStack {
                Ellipse()
                    .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                    .frame(width: 100.getWidth(), height: 20.getHeight())
                    .padding(.top, 116.getHeight())
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 138.getWidth(), height: 126.getHeight())
                    .padding(.leading, 15.getWidth())
            }
        }
    }
}

struct CustomChevron: View {
    var body: some View {
        ZStack {
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
