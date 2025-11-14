//
//  BlockModel.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import Foundation
import SwiftUI

struct BlockModel: Identifiable, Equatable {
    let id = UUID()
    let type: ShapeType
    let color: Color
    var isPlaced: Bool = false
}

struct BlockPosition {
    var id: UUID
    var position: CGPoint
    var size: CGSize
}
