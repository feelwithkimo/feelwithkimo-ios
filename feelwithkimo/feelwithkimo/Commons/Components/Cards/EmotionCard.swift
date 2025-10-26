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
                    .fill(ColorToken.grayscale50.toColor())
                    .frame(width: cardSize, height: cardSize)

                Image(systemName: emotion.visualCharacterName)
                    .font(.system(size: (cardSize)/2))
                    .foregroundColor(ColorToken.additionalColorsBlack.toColor())

            }

            // Label Nama Emosi
            Text(emotion.name)
                .font(.app(.caption1))
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .frame(width: capsuleWidth, height: capsuleHeight)
                .background(
                    Capsule()
                        .fill(ColorToken.grayscale30.toColor())
                )
        }
    }
}
