//
//  DashedCircleView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 05/11/25.
//

import SwiftUI

struct DashedCircleView: View {
    enum CircleType {
        case full
        case half(startAngle: Angle = .degrees(-90))
    }

    // Public API
    var type: CircleType = .full
    var lineWidth: CGFloat = 4
    var dash: [CGFloat] = [8, 6] // dash length, gap length
    var strokeColor: Color = .blue
    var size: CGSize = CGSize(width: 80, height: 80)
    var clockwise: Bool = true

    var body: some View {
        ZStack {
            DashedArcShape(type: type, clockwise: clockwise)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: dash))
                .foregroundColor(strokeColor)
                .frame(width: size.width, height: size.height)
        }
    }
}

// MARK: - Shape implementation
private struct DashedArcShape: Shape {
    let type: DashedCircleView.CircleType
    let clockwise: Bool

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // radius fits inside rect respecting lineWidth outside caller responsibility
        let radius = min(rect.width, rect.height) / 2

        // Convert Angle to radians; UIBezier uses clockwise positive, SwiftUI uses opposite for some transforms.
        func point(at angle: Angle) -> CGPoint {
            let radian = CGFloat(angle.radians)
            return CGPoint(
                x: center.x + radius * cos(radian),
                y: center.y + radius * sin(radian)
            )
        }

        var path = Path()

        switch type {
        case .full:
            path.addEllipse(in: CGRect(x: center.x - radius,
                                       y: center.y - radius,
                                       width: radius * 2,
                                       height: radius * 2))
        case .half(let startAngle):
            // Draw arc of 180 degrees from startAngle clockwise or counterclockwise
            let sweep: Angle = .degrees(180)
            let endAngle = clockwise ? startAngle + sweep : startAngle - sweep

            // Convert to SwiftUI Path arc (startAngle in degrees, 0 degrees points to +x axis)
            path.addArc(center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: !clockwise)
        }

        return path
    }
}

// MARK: - Previews & usage examples
struct DashedCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            // Full dashed circle
            DashedCircleView(
                type: .full,
                lineWidth: 4,
                dash: [10, 6],
                strokeColor: .purple,
                size: CGSize(width: 120, height: 120)
            )

            // Half dashed circle (starts from top, clockwise)
            DashedCircleView(
                type: .half(startAngle: .degrees(-90)),
                lineWidth: 6,
                dash: [12, 8],
                strokeColor: .green,
                size: CGSize(width: 140, height: 140),
                clockwise: true
            )

            // Half dashed circle (start from left, counter-clockwise)
            DashedCircleView(
                type: .half(startAngle: .degrees(180)),
                lineWidth: 3,
                dash: [6, 4],
                strokeColor: .orange,
                size: CGSize(width: 100, height: 100),
                clockwise: false
            )
            
            DashedCircleView(
                type: .half(startAngle: .degrees(180)),
                lineWidth: 4,
                dash: [6, 4],
                strokeColor: .red,
                size: CGSize(width: 100, height: 100),
                clockwise: false
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
