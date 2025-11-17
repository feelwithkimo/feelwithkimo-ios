//
//  KimoPauseButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 17/11/25.
//

import SwiftUI

struct KimoPauseButton: View {
    var body: some View {
        Image("Pause")
            .resizable()
            .frame(maxWidth: 100, maxHeight: 80)
            .kimoButtonAccessibility(
                label: "Berhenti",
                hint: "Hentikan permainan sebentar",
                identifier: "kimoPauseButton"
            )
    }
}

#Preview {
    KimoPauseButton()
}
