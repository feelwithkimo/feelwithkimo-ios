//
//  KimoCircleWrapper.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/11/25.
//

import SwiftUI

struct KimoCircleWrapper<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(ColorToken.corePinkDialogue.toColor())
                .frame(width: 50.getWidth(), height: 50.getHeight())
            content
        }
    }
}

#Preview {
    KimoCircleWrapper {
        Image(systemName: "chevron.right")
            .resizable()
            .scaledToFit()
            .foregroundColor(ColorToken.additionalColorsBlack.toColor())
            .frame(width: 14.getWidth(), height: 23.getHeight())
    }
}
