//
//  EmotionCard.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import SwiftUI

enum CardSize {
    static let capsuleWidth: CGFloat = 250.getWidth()
}

struct EmotionCard: View {
    // MARK: - Properties
    let emotion: EmotionModel
    let isSelected: Bool
    
    private var capsuleWidth: CGFloat {
        return isSelected ? CardSize.capsuleWidth * 1.2 : CardSize.capsuleWidth
    }
    
    private var spacerHeight: CGFloat {
        return isSelected ? 0 : 50.getHeight()
    }

    // MARK: - Body
    var body: some View {
        VStack {
            KimoImage(image: emotion.image, width: capsuleWidth.getWidth())
            
            Spacer(minLength: spacerHeight)
        }
        .kimoCardAccessibility(
            label: "Cerita \(emotion.title)\(isSelected ? ", terpilih" : "")",
            isSelected: isSelected,
            hint: "Ketuk dua kali untuk memilih cerita \(emotion.title)",
            identifier: "emotionCard.\(emotion.title.lowercased())"
        )
    }
}
