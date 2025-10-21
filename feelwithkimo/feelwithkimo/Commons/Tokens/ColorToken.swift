//
//  ColorToken.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation
import UIKit

enum ColorToken {
    // MARK: - Primary Colors

    @ColorElement(light: UIColor.from("#A394C5"), dark: UIColor.from("#A394C5"))
    static var mainColorPrimary: UIColor

    @ColorElement(light: UIColor.from("#DACFF3"), dark: UIColor.from("#DACFF3"))
    static var mainColorSecondary: UIColor

    @ColorElement(light: UIColor.from("#FAC0D8"), dark: UIColor.from("#FAC0D8"))
    static var mainColorPastelPink: UIColor

    // MARK: - Secondary Colors

    @ColorElement(light: UIColor.from("#ACECC7"), dark: UIColor.from("#ACECC7"))
    static var secondaryColorDarkGreen: UIColor

    @ColorElement(light: UIColor.from("#8EC2A7"), dark: UIColor.from("#8EC2A7"))
    static var secondaryColorYellow: UIColor

    @ColorElement(light: UIColor.from("#8EC2A7"), dark: UIColor.from("#8EC2A7"))
    static var secondaryColorRed: UIColor

    @ColorElement(light: UIColor.from("#9FD9F3"), dark: UIColor.from("#9FD9F3"))
    static var secondaryColorBlue: UIColor

    // MARK: - Additional Colors

    @ColorElement(light: UIColor.from("#FEFEFE"), dark: UIColor.from("#FEFEFE"))
    static var additionalColorsWhite: UIColor

    @ColorElement(light: UIColor.from("#000000"), dark: UIColor.from("#FFFFFF"))
    static var additionalColorsBlack: UIColor

    // MARK: - Grayscale Colors

    @ColorElement(light: UIColor.from("#FDFDFD"), dark: UIColor.from("#FDFDFD"))
    static var grayscale10: UIColor

    @ColorElement(light: UIColor.from("#ECF1F6"), dark: UIColor.from("#ECF1F6"))
    static var grayscale20: UIColor

    @ColorElement(light: UIColor.from("#E3E9ED"), dark: UIColor.from("#E3E9ED"))
    static var grayscale30: UIColor

    @ColorElement(light: UIColor.from("#D1D8DD"), dark: UIColor.from("#D1D8DD"))
    static var grayscale40: UIColor

    @ColorElement(light: UIColor.from("#BFC6CC"), dark: UIColor.from("#BFC6CC"))
    static var grayscale50: UIColor

    @ColorElement(light: UIColor.from("#9CA4AB"), dark: UIColor.from("#9CA4AB"))
    static var grayscale60: UIColor

    @ColorElement(light: UIColor.from("#78828A"), dark: UIColor.from("#FFFFFF").withAlphaComponent(0.75))
    static var grayscale70: UIColor

    @ColorElement(light: UIColor.from("#66707A"), dark: UIColor.from("#66707A"))
    static var grayscale80: UIColor

    @ColorElement(light: UIColor.from("#434E58"), dark: UIColor.from("#434E58"))
    static var grayscale90: UIColor

    @ColorElement(light: UIColor.from("#171725"), dark: UIColor.from("#171725"))
    static var grayscale100: UIColor
}
