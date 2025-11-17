//
//  EmotionModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation

struct EmotionModel: Decodable, Identifiable {
    let id: String
    let title: String
    let description: String
    let image: String
    var stories: [StoryModel]
}
