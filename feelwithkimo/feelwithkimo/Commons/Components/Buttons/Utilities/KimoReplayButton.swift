//
//  KimoReplayButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 17/11/25.
//

import SwiftUI

struct KimoReplayButton: View {
    var isLarge: Bool = false
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(image: "Replay", width: isLarge ? 120.getWidth() : 80.getWidth())
                .kimoButtonAccessibility(
                    label: "Kembali",
                    hint: "Ketuk dua kali untuk kembali ke halaman sebelumnya",
                    identifier: "kimoBackButton"
                )
        })
    }
}

#Preview("Kimo Replay Button Small") {
    KimoReplayButton()
}

#Preview ("Kimo Replay Button Large"){
    KimoReplayButton(isLarge: true)
}
