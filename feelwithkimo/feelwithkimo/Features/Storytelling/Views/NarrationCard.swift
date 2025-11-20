//
//  NarrationCard.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 05/11/25.
//

import SwiftUI

struct NarrationCard: View {
    let text: String

    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(ColorToken.additionalColorsWhite.toColor())
            .overlay(
                Text(text)
                    .font(.customFont(size: 22, family: .primary, weight: .bold))
                    .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                    .padding(.horizontal, 24.getWidth())
                    .padding(.vertical, 16.getHeight())
                    .multilineTextAlignment(.center)
                    .kimoTextAccessibility(label: "Narasi: \(text)", identifier: "story.narration.text"),
                alignment: .center
            )
            .frame(
                width: 840.getWidth(),
                height: 120.getHeight()
            )
            .padding(.horizontal, 177.getWidth())
            .padding(.top, 11.getHeight())
    }
}
