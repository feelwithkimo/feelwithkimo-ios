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

enum KimoVisual: String, Decodable {
    case normal
    case mark
    case star
}

struct StorySceneModel: Decodable {
    let path: String
    let text: String
    var isEnd: Bool
    var nextScene: [Int]
    var kimoText: String?
    
    var question: QuestionOption?
    var kimoVisual: KimoVisual?
    var interactionType: InteractionType?

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
        self.nextScene = nextScene
        self.kimoText = kimoText
        
        self.question = question
        self.kimoVisual = kimoVisual
        self.interactionType = interactionType
    }
    
    enum CodingKeys: String, CodingKey {
        case path,
             text,
             nextScene,
             kimoVisual,
             kimoText,
             question,
             interactionType,
            isEnd
    }
}

struct QuestionOption: Decodable {
    let question: String
    let option: [String]
}
