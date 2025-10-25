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
        UIFont.appFont(forTextStyle: textStyle, family: family).toFont()
    }
}
