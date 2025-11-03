//
//  EmotionCard.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import SwiftUI

enum CardSize {
    static let eclipseSize: CGFloat = 217.06
    static let capsuleWidth: CGFloat = 190.14
    static let capsuleHeight: CGFloat = 44.28
}

struct EmotionCard: View {
    // MARK: - Properties
    let emotion: EmotionModel
    let isSelected: Bool

    private var cardSize: CGFloat {
        return isSelected ? CardSize.eclipseSize * 1.2 : CardSize.eclipseSize
    }

    private var capsuleWidth: CGFloat {
        return isSelected ? CardSize.capsuleWidth * 1.2 : CardSize.capsuleWidth
    }

    private var capsuleHeight: CGFloat {
        return isSelected ? CardSize.capsuleHeight * 1.2 : CardSize.capsuleHeight
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: -12) {
            // "Karakter Visual" Placeholder
            ZStack {
                Circle()
                    .fill(ColorToken.backgroundCard.toColor())
                    .frame(width: cardSize, height: cardSize)

                Image(systemName: emotion.visualCharacterName)
                    .font(.system(size: (cardSize) / 2))
                    .foregroundStyle(ColorToken.textPrimary.toColor())
                    .kimoImageAccessibility(
                        label: "Ikon emosi \(emotion.name)",
                        isDecorative: false,
                        identifier: "emotionCard.icon.\(emotion.name.lowercased())"
                    )

            }

            // Label Nama Emosi
            Text(emotion.name)
                .font(.app(.caption1, family: .primary))
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(ColorToken.textPrimary.toColor())
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .frame(width: capsuleWidth, height: capsuleHeight)
                .background(
                    Capsule()
                        .fill(ColorToken.corePrimary.toColor())
                )
                .kimoTextAccessibility(
                    label: emotion.name,
                    identifier: "emotionCard.label.\(emotion.name.lowercased())"
                )
        }
        .kimoCardAccessibility(
            label: "Kartu emosi \(emotion.name)\(isSelected ? ", terpilih" : "")",
            isSelected: isSelected,
            hint: "Ketuk dua kali untuk memilih emosi \(emotion.name)",
            identifier: "emotionCard.\(emotion.name.lowercased())"
        )
    }
}
