///
///  BlockModel.swift
///  feelwithkimo
///
///  Created by Adeline Charlotte Augustinne on 14/11/25.
///

import Foundation
import SwiftUI

struct BlockModel: Identifiable, Equatable {
    let id: UUID
    let type: ShapeType
    let baseColor: Color
    let strokeColor: Color
    
    init(id: UUID = UUID(), type: ShapeType, baseColor: Color, strokeColor: Color) {
        self.id = id
        self.type = type
        self.baseColor = baseColor
        self.strokeColor = strokeColor
    }
}

struct BlockPosition {
    var id: UUID
    var position: CGPoint
    var size: CGSize
}
