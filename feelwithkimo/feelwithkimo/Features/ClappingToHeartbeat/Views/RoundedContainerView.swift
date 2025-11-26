//
//  RoundedRectangleView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 06/11/25.
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
                 RoundedRectangle(cornerRadius: 26)
                    .stroke(ColorToken.corePrimary.toColor(), lineWidth: 19)
             )
            .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}
