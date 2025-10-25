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

    /// Unified function for custom font with Apple Dynamic Type support
    static func appFont(
        forTextStyle style: UIFont.TextStyle,
        family: FontFamily = .primary
    ) -> UIFont {
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        let weight = weightForTextStyle(style)

        let fontName: String = {
            switch (family, weight) {
            case (.primary, .regular): return "Quicksand-Regular"
            case (.primary, .semibold): return "Quicksand-SemiBold"
            case (.primary, .bold): return "Quicksand-Bold"

            case (.secondary, .regular): return "Nunito-Regular"
            case (.secondary, .semibold): return "Nunito-SemiBold"
            case (.secondary, .bold): return "Nunito-Bold"

            default: return "\(family.rawValue)-Regular"
            }
        }()

        guard let customFont = UIFont(name: fontName, size: pointSize) else {
            assertionFailure("❌ Failed to load font: \(fontName). Check .ttf or Info.plist registration.")
            return UIFont.preferredFont(forTextStyle: style)
        }

        // Enable Dynamic Type scaling
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
    }

    /// Map Apple text styles to preferred font weight
    private static func weightForTextStyle(_ style: UIFont.TextStyle) -> UIFont.Weight {
        switch style {
        case .largeTitle, .title1, .title2, .title3:
            return .bold
        case .headline:
            return .semibold
        default:
            return .regular
        }
    }

    /// SwiftUI convenience
    func toFont(relativeTo textStyle: UIFont.TextStyle) -> Font {
        // Map UIFont.TextStyle → SwiftUI.Font.TextStyle
        let relativeStyle: Font.TextStyle
        switch textStyle {
        case .largeTitle: relativeStyle = .largeTitle
        case .title1: relativeStyle = .title
        case .title2: relativeStyle = .title2
        case .title3: relativeStyle = .title3
        case .headline: relativeStyle = .headline
        case .subheadline: relativeStyle = .subheadline
        case .body: relativeStyle = .body
        case .callout: relativeStyle = .callout
        case .footnote: relativeStyle = .footnote
        case .caption1: relativeStyle = .caption
        case .caption2: relativeStyle = .caption2
        default: relativeStyle = .body
        }

        return .custom(fontName, size: pointSize, relativeTo: relativeStyle)
    }
}
