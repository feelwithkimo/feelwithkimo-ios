//
//  KimoBubbleButtonTertiary.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct KimoBubbleButtonTertiary: View {
    var buttonLabel: String = NSLocalizedString("Lets_Start", comment: "")
    
    var body: some View {
        ZStack {
            Image("KimoBubbleButtonTertiary")
                .resizable()
                .scaledToFit()
                .frame(width: 253.getWidth(), height: 74.getHeight())
                .padding(0)
            
            Text(buttonLabel)
                .font(.customFont(size: 28, family: .primary, weight: .bold))
                .foregroundStyle(ColorToken.textPrimary.toColor())
                .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 253.getWidth(), maxHeight: 74.getHeight())
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(ColorToken.strokeButton.toColor(), lineWidth: 5.0)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .fill(
                    Color.clear
                        .shadow(.inner(
                            color: ColorToken.backgroundSecondary.toColor().opacity(0.5),
                            radius: 1.9,
                            x: 5,
                            y: -3
                        ))
                        .shadow(
                            .drop(
                                color: ColorToken.backgroundSecondary.toColor().opacity(0.5),
                                radius: 20.0,
                                x: 0,
                                y: 4
                            )
                        )
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

#Preview {
    KimoBubbleButtonTertiary()
}
