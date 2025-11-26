//
//  KimoResumeButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 18/11/25.
//

import SwiftUI

struct KimoResumeButton: View {
    var isLarge: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(image: "Resume", width: isLarge ? 120.getWidth() : 80.getWidth())
                .kimoButtonAccessibility(
                    label: "Kembali",
                    hint: "Ketuk dua kali untuk kembali ke halaman sebelumnya",
                    identifier: "kimoBackButton"
                )
        })
    }
}

#Preview {
    KimoResumeButton()
}
