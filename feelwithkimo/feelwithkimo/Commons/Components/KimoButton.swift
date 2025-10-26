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
            .font(.title3)
            .bold()
            .padding(.horizontal, 26)
            .padding(.vertical, 18)
            .background(ColorToken.additionalColorsBlack.toColor())
            .foregroundColor(ColorToken.additionalColorsWhite.toColor())
            .cornerRadius(50)
            .accessibilitySortPriority(3)
    }
}
