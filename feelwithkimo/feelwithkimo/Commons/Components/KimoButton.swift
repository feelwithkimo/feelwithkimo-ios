//
//  KimoButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/10/25.
//

import SwiftUI

struct KimoButton: View {
    var textLabel: String
    
    var body: some View {
        Text(textLabel)
            .font(.app(.title1, family: .primary))
            .padding(.horizontal, 26)
            .padding(.vertical, 18)
            .background(ColorToken.backgroundCard.toColor())
            .foregroundStyle(ColorToken.textPrimary.toColor())
            .cornerRadius(50)
            .kimoButtonAccessibility(
                label: textLabel,
                hint: nil,
                identifier: "kimoButton.\(textLabel.lowercased().replacingOccurrences(of: " ", with: ""))"
            )
            .accessibilitySortPriority(3)
    }
}
