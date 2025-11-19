//
//  KimoHomeButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 18/11/25.
//

import SwiftUI

struct KimoHomeButton: View {
    var isLarge: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(image: "Home", width: isLarge ? 120.getWidth() : 80.getWidth())
                .kimoButtonAccessibility(
                    label: "Beranda",
                    hint: "Ketuk untuk kembali ke beranda",
                    identifier: "kimoHomeButton"
                )
        })
    }
}

#Preview {
    KimoHomeButton()
}
