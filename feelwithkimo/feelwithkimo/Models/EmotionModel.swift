//
//  EmotionModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation

struct EmotionModel: Identifiable {
    let id: UUID
    let name: String
    let visualCharacterName: String
    let emotionImage: String
    let title: String
    let description: String
    var stories: [StoryModel]
}
