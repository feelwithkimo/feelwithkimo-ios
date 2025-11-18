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
            .frame(width: 80, height: 80)
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
