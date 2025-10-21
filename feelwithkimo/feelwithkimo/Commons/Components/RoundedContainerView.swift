//
//  RoundedContainerView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 21/10/25.
//

import SwiftUI

struct RoundedContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red, lineWidth: 20)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
