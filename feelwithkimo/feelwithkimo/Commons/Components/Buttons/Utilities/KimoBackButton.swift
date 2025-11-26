//
//  KimoBackButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/10/25.
//

import SwiftUI

struct KimoBackButton: View {
    let imagePath: String
    let isLarge: Bool
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(image: imagePath, width: isLarge ? 120.getWidth() : 80.getWidth())
                .kimoButtonAccessibility(
                    label: "Kembali",
                    hint: "Ketuk dua kali untuk kembali ke halaman sebelumnya",
                    identifier: "kimoBackButton"
                )
        })
    }
}

#Preview {
    KimoBackButton(imagePath: "Back", isLarge: true)
}
