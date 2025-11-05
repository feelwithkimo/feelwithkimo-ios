//
//  KimoCloseButton.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 04/11/25.
//

import SwiftUI

struct KimoCloseButton: View {
    var body: some View {
        Image("Close")
            .resizable()
            .frame(maxWidth: 55, maxHeight: 55)
            .kimoButtonAccessibility(
                label: "Tutup",
                hint: "Ketuk dua kali untuk menutup halaman ini",
                identifier: "kimoCloseButton"
            )
    }
}

#Preview {
    KimoCloseButton()
}
