//
//  ClappingTutorialStep.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/11/25.
//

import SwiftUI

struct ClappingTutorialStep: View {
    let image: String
    let stepNumber: String
    let description: String

    var body: some View {
        VStack(spacing: 10.getHeight()) {
            KimoImage(image: image, width: 169.getWidth())

            KimoCircleWrapper {
                Text(stepNumber)
                    .font(.customFont(size: 22, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
            }

            Text(description)
                .font(.customFont(size: 15, weight: .regular))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                .multilineTextAlignment(.center)
        }
        .frame(width: 196.getWidth())
    }
}
