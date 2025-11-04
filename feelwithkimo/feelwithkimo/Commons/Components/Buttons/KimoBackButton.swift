//
//  KimoBackButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/10/25.
//

import SwiftUI

struct KimoBackButton: View {
    var body: some View {
        Image("Back")
            .resizable()
            .frame(maxWidth: 55, maxHeight: 55)
            .kimoButtonAccessibility(
                label: "Kembali",
                hint: "Ketuk dua kali untuk kembali ke halaman sebelumnya",
                identifier: "kimoBackButton"
            )
    }
}
