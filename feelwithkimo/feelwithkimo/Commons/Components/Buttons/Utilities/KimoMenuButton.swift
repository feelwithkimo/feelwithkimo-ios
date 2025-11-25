//
//  KimoMenuButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 25/11/25.
//

import SwiftUI

struct KimoMenuButton: View {
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image("Menu")
                .resizable()
                .scaledToFit()
                .frame(width: 80.getWidth(), height: 80.getWidth())
                .kimoButtonAccessibility(
                    label: NSLocalizedString("Menu", comment: ""),
                    hint: "Hentikan permainan sebentar",
                    identifier: "kimoMenuButton"
                )
        }
    )}
}

#Preview {
    KimoMenuButton()
}
