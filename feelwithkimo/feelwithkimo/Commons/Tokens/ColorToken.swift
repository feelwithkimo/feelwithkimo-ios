//
//  ColorToken.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation
import UIKit

enum ColorToken {
    
    // MARK: - Core Colors
    @ColorElement(light: UIColor.from("#A394C5"), dark: UIColor.from("#C9B8EB"))
    static var corePrimary: UIColor

    @ColorElement(light: UIColor.from("#FAC0D8"), dark: UIColor.from("#F4BBCD"))
    static var coreSecondary: UIColor

    @ColorElement(light: UIColor.from("#E7B6CB"), dark: UIColor.from("#E7B6CB"))
    static var coreSecondaryTwo: UIColor
    
    @ColorElement(light: UIColor.from("#F6F0FF"), dark: UIColor.from("#F6F0FF"))
    static var corePinkDialogue: UIColor
    
    @ColorElement(light: UIColor.from("#EFEAFF"), dark: UIColor.from("#EFEAFF"))
    static var corePinkStory: UIColor

    @ColorElement(light: UIColor.from("#ACECC7"), dark: UIColor.from("#A1D8C5"))
    static var coreAccent: UIColor
    
    @ColorElement(light: UIColor.from("#C9B8E8"), dark: UIColor.from("#C9B8E8"))
    static var coreLightPrimary: UIColor

    // MARK: - Emotion Colors
    @ColorElement(light: UIColor.from("#FFE680"), dark: UIColor.from("#FFDB4D"))
    static var emotionJoy: UIColor

    @ColorElement(light: UIColor.from("#9FD9F3"), dark: UIColor.from("#5CACD9"))
    static var emotionSadness: UIColor

    @ColorElement(light: UIColor.from("#FF4850"), dark: UIColor.from("#E03A3F"))
    static var emotionAnger: UIColor

    @ColorElement(light: UIColor.from("#B3A7E6"), dark: UIColor.from("#8570D1"))
    static var emotionFear: UIColor

    @ColorElement(light: UIColor.from("#CFCFCF"), dark: UIColor.from("#6F6F6F"))
    static var emotionTired: UIColor

    @ColorElement(light: UIColor.from("#C5B2FF"), dark: UIColor.from("#A48CFF"))
    static var emotionSurprise: UIColor

    @ColorElement(light: UIColor.from("#8EC2A7"), dark: UIColor.from("#4D866C"))
    static var emotionDisgusted: UIColor

    // MARK: - Background
    @ColorElement(light: UIColor.from("#1C1628"), dark: UIColor.from("#FFFDFB"))
    static var backgroundMain: UIColor
    
    @ColorElement(light: UIColor.from("5E5573"), dark: UIColor.from("#5E5573"))
    static var backgroundSecondary: UIColor
    
    @ColorElement(light: UIColor.from("#E9E3F9"), dark: UIColor.from("#E9E3F9"))
    static var backgroundBreathing: UIColor
    
    @ColorElement(light: UIColor.from("#2A213A"), dark: UIColor.from("#F5F1FA"))
    static var backgroundCard: UIColor
    
    @ColorElement(light: UIColor.from("#C0B4DF"), dark: UIColor.from("#C0B4DF"))
    static var backgroundEntry: UIColor
    
    @ColorElement(light: UIColor.from("#FFF5C9"), dark: UIColor.from("#FFF5C9"))
    static var backgroundHome: UIColor
    
    @ColorElement(light: UIColor.from("#CEE5FA"), dark: UIColor.from("#CEE5FA"))
    static var ellipseHome: UIColor

    @ColorElement(light: UIColor.from("#CDF0FF"), dark: UIColor.from("#CDF0FF"))
    static var backgroundIdentity: UIColor
    
    // MARK: - Text
    @ColorElement(light: UIColor.from("#FFFFFF"), dark: UIColor.from("#352E4A"))
    static var textPrimary: UIColor

    @ColorElement(light: UIColor.from("#C4B8D9"), dark: UIColor.from("#6C6487"))
    static var textSecondary: UIColor
    
    // MARK: - Status
    @ColorElement(light: UIColor.from("#CFC0BB"), dark: UIColor.from("#7C728D"))
    static var statusDisabled: UIColor

    @ColorElement(light: UIColor.from("#FF858B"), dark: UIColor.from("#BF777F"))
    static var statusError: UIColor

    @ColorElement(light: UIColor.from("#A6E5B5"), dark: UIColor.from("#95DAB2"))
    static var statusSuccess: UIColor
    
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
    
    // MARK: - Stroke Button
    @ColorElement(light: UIColor.from("#DBDAF9"), dark: UIColor.from("#DBDAF9"))
    static var strokeButton: UIColor
}
