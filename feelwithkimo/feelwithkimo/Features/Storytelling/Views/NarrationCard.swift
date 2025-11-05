//
//  NarrationCard.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 05/11/25.
//

import SwiftUI

struct NarrationCard: View {
    let text: String
    let onTap: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(ColorToken.backgroundCard.toColor())
            .overlay(
                Text(text)
                    .font(.app(.headline, family: .primary))
                    .foregroundColor(.white)
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
            .padding(.bottom, 49.getHeight())
            .padding(.top, 11.getHeight())
            .onTapGesture(perform: onTap)
    }
}
