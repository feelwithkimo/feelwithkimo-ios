//
//  StoryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation
import SwiftUI

class StoryViewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var hasCompletedBreathing: Bool = false

    var story: StoryModel = StoryModel(
        id: UUID(),
        name: "Story Angry 1",
        thumbnail: "Thumbnail 1",
        description: "Description",
        storyScene: []
    )

    init() {
        self.fetchStory()
    }

    /// Load story scene
    private func fetchStory() {
        var scenes: [StorySceneModel] = []

        for number in 1...16 {
            scenes.append(StorySceneModel(path: "Scene \(number)", text: ""))
        }

        self.story.storyScene = scenes
    }

    /// function to next scene
    func goScene(to number: Int) {
        switch number {
        case 1:
            guard index < story.storyScene.count - 1 else { return }
            withAnimation(.easeInOut(duration: 1.5)) { index += 1 }
        case -1:
            guard index > 0 else { return }
            withAnimation(.easeInOut(duration: 1.5)) { index -= 1 }
        case 13:
            guard index == 13 else { return }
        default:
            break
        }
    }
    
    /// Mark breathing exercise as completed
    func completeBreathingExercise() {
        hasCompletedBreathing = true
        print("✅ Breathing exercise completed! Button text will change to 'Lanjut'")
    }
}
