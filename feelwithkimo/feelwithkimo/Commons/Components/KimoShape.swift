//
//  KimoShape.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

private func isInvalid(_ rect: CGRect) -> Bool {
    rect.width <= 0 || rect.height <= 0 || rect.width.isNaN || rect.height.isNaN
}

extension Shape {
    func dashedStroke(color: Color, lineWidth: CGFloat = 2, dash: [CGFloat] = [6]) -> some View {
        self.stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dash))
            .foregroundColor(color)
    }
}

func shape(for type: ShapeType) -> AnyShape {
    switch type {
    case .square:
        return AnyShape(SquareShape())
    case .rectangle:
        return AnyShape(RectangleShape(ratio: .ratio3to1))
    case .arch:
        return AnyShape(ArchShape())
    case .triangle:
        return AnyShape(TriangleShape())
    }
}

struct SquareShape: Shape {
    func path(in rect: CGRect) -> Path {
        if isInvalid(rect) { return Path() }

        let side = min(rect.width, rect.height)
        let offsetX = (rect.width - side) / 2
        let offsetY = (rect.height - side) / 2

        var path = Path()
        path.addRect(
            CGRect(
                x: rect.minX + offsetX,
                y: rect.minY + offsetY,
                width: side,
                height: side
            )
        )
        return path
    }
}

struct RectangleShape: Shape {
    let ratio: RectangleRatio
    
    func path(in rect: CGRect) -> Path {
        if isInvalid(rect) { return Path() }

        let aspect = ratio.value
        
        var width = max(rect.width, 1)
        var height = width / aspect
        
        if height > rect.height {
            height = max(rect.height, 1)
            width = height * aspect
        }
        
        let positionX = rect.midX - width / 2
        let positionY = rect.midY - height / 2
        
        var path = Path()
        path.addRect(CGRect(x: positionX, y: positionY, width: width, height: height))
        return path
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        if isInvalid(rect) { return Path() }

        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct ArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        if isInvalid(rect) { return Path() }

        var path = Path()
        path.addRect(rect)
        
        let diameter = max(rect.height, 1)
        let radius = diameter / 2
        
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        
        let circleRect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: diameter,
            height: diameter
        )
        
        var cutout = Path()
        cutout.addEllipse(in: circleRect)
        
        return path.subtracting(cutout)
    }
}

#Preview("Square") {
    SquareShape()
}

#Preview("Rectangle (3:1)") {
    RectangleShape(ratio: .ratio3to1)
}

#Preview("Rectangle (25:6)") {
    RectangleShape(ratio: .ratio25to6)
}

#Preview("Triangle"){
    TriangleShape()
}

#Preview("Arch"){
    ArchShape()
}
