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
        return Font.custom(font.fontName, size: font.pointSize, relativeTo: mapToSwiftUITextStyle(textStyle))
    }

    private static func mapToSwiftUITextStyle(_ style: UIFont.TextStyle) -> Font.TextStyle {
        switch style {
        case .largeTitle: return .largeTitle
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption1: return .caption
        case .caption2: return .caption2
        default: return .body
        }
    }
}
