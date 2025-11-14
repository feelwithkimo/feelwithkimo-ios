//
//  KimoShape.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

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
        let side = min(rect.width, rect.height)
        let offsetX = (rect.width - side) / 2
        let offsetY = (rect.height - side) / 2
        
        var p = Path()
        p.addRect(
            CGRect(x: rect.minX + offsetX,
                   y: rect.minY + offsetY,
                   width: side,
                   height: side)
        )
        return p
    }
}

struct RectangleShape: Shape {
    let ratio: RectangleRatio 
    
    func path(in rect: CGRect) -> Path {
        let aspect = ratio.value
        
        var width = rect.width
        var height = width / aspect
        
        if height > rect.height {
            height = rect.height
            width = height * aspect
        }
        
        let x = rect.midX - width / 2
        let y = rect.midY - height / 2
        
        var p = Path()
        p.addRect(.init(x: x, y: y, width: width, height: height))
        return p
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct ArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        p.addRect(rect)
        
        let diameter = rect.height
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
        
        return p.subtracting(cutout)
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
