//
//  EntryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 27/11/25.
//

import Foundation

internal class EntryViewModel: ObservableObject {
    @Published var entrySound: Bool = false
    @Published var emotion: EmotionModel = EmotionModel(
        id: "",
        title: "",
        description: "",
        image: "",
        stories: []
    )

    init(emotion: EmotionModel? = nil, path: String) {
        self.fetchStory(story: path)
    }

    private func fetchStory(story storyPath: String, defaultStoryPath: String = "Balok") {
        var emotionModel: EmotionModel! = JSONLoader.load(EmotionModel.self, from: storyPath, fallback: defaultStoryPath)
        if emotionModel == nil {
            emotionModel = EmotionModel(
                id: "",
                title: "",
                description: "",
                image: "",
                stories: []
            )
        }
        self.emotion = emotionModel
    }
}
