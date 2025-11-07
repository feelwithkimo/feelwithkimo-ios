//
//  UIFont+ext.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/10/25.
//

import SwiftUI

extension UIFont {
    enum FontFamily: String {
        case primary = "Quicksand"
        case secondary = "Nunito"
    }
    
    /// Adaptive font (scales with Dynamic Type)
    static func appFont(
        forTextStyle style: UIFont.TextStyle,
        family: FontFamily = .primary
    ) -> UIFont {
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        let weight = weightForTextStyle(style)
        
        let fontName = resolveFontName(for: family, weight: weight)
        
        guard let customFont = UIFont(name: fontName, size: pointSize) else {
            assertionFailure("❌ Failed to load font: \(fontName)")
            return UIFont.preferredFont(forTextStyle: style)
        }
        
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }
    
    /// 🔹 Static font (does not scale with Dynamic Type)
    static func appFont(
        size: CGFloat,
        family: FontFamily = .primary,
        weight: UIFont.Weight = .regular
    ) -> UIFont {
        let fontName = resolveFontName(for: family, weight: weight)
        guard let customFont = UIFont(name: fontName, size: size) else {
            assertionFailure("❌ Failed to load font: \(fontName)")
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
        return customFont
    }
    
    private static func resolveFontName(for family: FontFamily, weight: UIFont.Weight) -> String {
        switch (family, weight) {
        case (.primary, .regular): return "Quicksand-Regular"
        case (.primary, .semibold): return "Quicksand-SemiBold"
        case (.primary, .bold): return "Quicksand-Bold"
        case (.secondary, .regular): return "Nunito-Regular"
        case (.secondary, .semibold): return "Nunito-SemiBold"
        case (.secondary, .bold): return "Nunito-Bold"
        default: return "\(family.rawValue)-Regular"
        }
    }
    
    private static func weightForTextStyle(_ style: UIFont.TextStyle) -> UIFont.Weight {
        switch style {
        case .largeTitle, .title1, .title2, .title3: return .bold
        case .headline: return .semibold
        default: return .regular
        }
    }
    
    /// Centralized mapping to SwiftUI.Font.TextStyle
    static func mapToSwiftUITextStyle(_ style: UIFont.TextStyle) -> Font.TextStyle {
        let styleMap: [UIFont.TextStyle: Font.TextStyle] = [
            .largeTitle: .largeTitle,       // 34 px
            .title1: .title,                // 28 px
            .title2: .title2,               // 22 px
            .title3: .title3,               // 20 px
            .headline: .headline,           // 18 px
            .subheadline: .subheadline,     // 17 px
            .body: .body,                   // 16 px
            .callout: .callout,             // 15 px
            .footnote: .footnote,           // 13 px
            .caption1: .caption,            // 12 px
            .caption2: .caption2            // 11 px
        ]
        return styleMap[style] ?? .body
    }
    
    /// SwiftUI convenience
    func toFont(relativeTo textStyle: UIFont.TextStyle) -> Font {
        return .custom(fontName, size: pointSize, relativeTo: UIFont.mapToSwiftUITextStyle(textStyle))
    }
}
