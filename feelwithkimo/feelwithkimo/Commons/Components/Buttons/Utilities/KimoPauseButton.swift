//
//  KimoPauseButton.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 17/11/25.
//

import SwiftUI

struct KimoPauseButton: View {
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image("Pause")
                .resizable()
                .frame(width: 100, height: 80)
                .kimoButtonAccessibility(
                    label: "Berhenti",
                    hint: "Hentikan permainan sebentar",
                    identifier: "kimoPauseButton"
                )
        }
    )}
}

#Preview {
    KimoPauseButton()
}
