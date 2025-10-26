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
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .submitLabel(.done)
    }
}
