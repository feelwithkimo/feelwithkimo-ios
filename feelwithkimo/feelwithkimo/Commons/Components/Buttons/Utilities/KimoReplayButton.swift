//
//  KimoReplayButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 17/11/25.
//

import SwiftUI

struct KimoReplayButton: View {
    var body: some View {
        Image("Replay")
            .resizable()
            .frame(maxWidth: 80, maxHeight: 80)
            .kimoButtonAccessibility(
                label: "Ulangi",
                hint: "Ulangi permainan",
                identifier: "kimoReplayButton"
            )
    }
}

#Preview {
    KimoReplayButton()
}
