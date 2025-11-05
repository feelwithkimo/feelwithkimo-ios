//
//  EmotionStoryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation

internal class EmotionStoryViewModel: ObservableObject {
    var emotion: EmotionModel

    init (emotion: EmotionModel) {
        self.emotion = emotion
    }
}
