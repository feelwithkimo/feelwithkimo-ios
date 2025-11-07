//
//  Font+ext.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/10/25.
//

import SwiftUI

extension Font {
    static func app(
        _ textStyle: UIFont.TextStyle,
        family: UIFont.FontFamily = .primary
    ) -> Font {
        let font = UIFont.appFont(forTextStyle: textStyle, family: family)
        return Font.custom(font.fontName, size: font.pointSize, relativeTo: UIFont.mapToSwiftUITextStyle(textStyle))
    }
    
    static func app(
        size: CGFloat,
        family: UIFont.FontFamily = .primary,
        weight: UIFont.Weight = .regular
    ) -> Font {
        let font = UIFont.appFont(size: size, family: family, weight: weight)
        return .custom(font.fontName, size: size)
    }
}
