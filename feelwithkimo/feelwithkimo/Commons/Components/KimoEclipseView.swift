//
//  KimoEclipseView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 06/11/25.
//

import SwiftUI

struct KimoEllipseView: View {
    var color: Color
    var height: CGFloat
    var body: some View {
        VStack {
            Ellipse()
                .trim(from: 0.5, to: 1)
                .fill(color)
                .frame(height: height.getHeight())
        }
    }
}

#Preview {
    KimoEllipseView(color: ColorToken.ellipseHome.toColor(), height: 674)
}
