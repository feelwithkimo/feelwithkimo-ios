//
//  BlockEnums.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 14/11/25.
//

import SwiftUI

enum ShapeType: String {
    case rectangle, square, arch, triangle
}

enum GameLevel: CaseIterable {
    case level1, level2
    
    var blocks: [BlockModel] {
        switch self {
        case .level1:
            return [
                BlockModel(type: .rectangle, color: Color.yellow),
                BlockModel(type: .square, color: Color.green),
                BlockModel(type: .arch, color: Color.pink)
            ]
        case .level2:
            return [
                BlockModel(type: .triangle, color: Color.yellow),
                BlockModel(type: .rectangle, color: Color.pink),
                BlockModel(type: .square, color: Color.blue)
            ]
        }
    }
}
