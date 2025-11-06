//
//  KimoEllipseView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 06/11/25.
//

import SwiftUI

struct KimoEllipseView2: View {
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
    KimoEllipseView2(color: ColorToken.ellipseHome.toColor(), height: 674)
}

struct KimoEllipseView: View {
    var body: some View {
        GeometryReader { geometry in
            Ellipse()
                .trim(from: 0.5, to: 1)
                .fill(ColorToken.backgroundEntry.toColor().opacity(0.5))
                .frame(width: geometry.size.width, height: geometry.size.height * 0.74)
        }
    }
}

#Preview {
    KimoEllipseView()
}
