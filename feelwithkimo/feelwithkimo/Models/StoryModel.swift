//
//  StoryModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation

struct StoryModel: Identifiable {
    let id: UUID
    let name: String
    let thumbnail: String
    let description: String
    var storyScene: [StorySceneModel]
}

enum KimoVisual {
    case normal
    case mark // Tanda seru
    case star
}

internal class StorySceneModel {
    let path: String
    let text: String
    var isEnd: Bool
    var question: QuestionOption?
    var nextScene: [Int]
    var interactionType: InteractionType
    
    var kimoVisual: KimoVisual
    var kimoText: String

    init(path: String,
         text: String,
         isEnd: Bool = false,
         question: QuestionOption? = nil,
         nextScene: [Int] = [],
         interactionType: InteractionType = .normal,
         kimoVisual: KimoVisual = .normal,
         kimoText: String = "") {
        self.path = path
        self.text = text
        self.isEnd = isEnd
        self.question = question
        self.nextScene = nextScene
        self.interactionType = interactionType
        self.kimoVisual = kimoVisual
        self.kimoText = kimoText
    }
}

struct QuestionOption {
    let question: String
    let option: [String]
}
