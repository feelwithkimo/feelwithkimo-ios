//
//  View+ext.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 16/11/25.
//

import SwiftUI

extension View {
    func readPosition(_ onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewPositionKey.self,
                                value: proxy.frame(in: .global))
            }
        )
        .onPreferenceChange(ViewPositionKey.self, perform: onChange)
    }
}
