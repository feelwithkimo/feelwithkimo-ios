//
//  KimoTextField.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/10/25.
//

import SwiftUI

struct KimoTextField: View {
    var placeholder: String
    @Binding var inputText: String
    
    var body: some View {
        TextField(placeholder, text: $inputText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(ColorToken.grayscale40.toColor(), lineWidth: 1)
            )
            .submitLabel(.done)
            .kimoAccessibility(
                label: "Kolom teks",
                hint: "Ketuk dua kali untuk mulai mengetik. Placeholder: \(placeholder)",
                traits: .isSearchField,
                identifier: "kimoTextField.\(placeholder.lowercased().replacingOccurrences(of: " ", with: ""))"
            )
    }
}
