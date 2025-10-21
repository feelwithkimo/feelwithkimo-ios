//
//  SoundIdentifier.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation

/// A sound that the app monitors for breathing detection
struct SoundIdentifierModel: Hashable {
    /// An internal name that identifies a sound classification
    var labelName: String

    /// A name suitable for displaying to a user
    var displayName: String

    /// Creates a sound identifier using an internal sound classification name
    init(labelName: String) {
        self.labelName = labelName
        self.displayName = SoundIdentifierModel.displayNameForLabel(labelName)
    }

    /// Converts a sound classification label to a name suitable for displaying
    static func displayNameForLabel(_ label: String) -> String {
        let unlocalized = label.replacingOccurrences(of: "_", with: " ").capitalized
        return unlocalized
    }
}
