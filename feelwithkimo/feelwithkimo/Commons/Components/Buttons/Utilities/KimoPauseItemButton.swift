//
//  KimoPauseItemButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 24/11/25.
//

import SwiftUI

struct KimoPauseItemButton: View {
    let imagePath: String
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(image: imagePath, width: 120.getWidth())
                .kimoButtonAccessibility(
                    label: "Kembali",
                    hint: "Ketuk dua kali untuk kembali ke halaman sebelumnya",
                    identifier: "kimoBackButton"
                )
        })
    }
}
