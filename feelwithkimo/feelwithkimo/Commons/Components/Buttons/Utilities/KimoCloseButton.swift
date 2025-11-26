//
//  KimoCloseButton.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 04/11/25.
//

import SwiftUI

struct KimoCloseButton: View {
    var isLarge: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image("xmark")
                .resizable()
                .scaledToFit()
                .frame(width: isLarge ? 120.getWidth() : 80.getWidth())
                .kimoButtonAccessibility(
                    label: "Tutup",
                    hint: "Ketuk dua kali untuk menutup halaman ini",
                    identifier: "kimoCloseButton"
                )
        })
    }
}

#Preview {
    KimoCloseButton()
}
