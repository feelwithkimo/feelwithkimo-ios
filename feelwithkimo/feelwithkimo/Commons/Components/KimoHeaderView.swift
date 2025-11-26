//
//  KimoHeaderView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/10/25.
//

import SwiftUI

struct KimoHeaderView<Content: View>: View {
    let content: () -> Content
    var height: CGFloat = 140

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(ColorToken.emotionSurprise.toColor()))
                .shadow(radius: 4)
            
            content()
        }
        .ignoresSafeArea(.container, edges: .top)
        .frame(height: height)
    }
}
