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
    let color: Color
    
    init(id: UUID = UUID(), type: ShapeType, color: Color) {
        self.id = id
        self.type = type
        self.color = color
    }
}

struct BlockPosition {
    var id: UUID
    var position: CGPoint
    var size: CGSize
}
