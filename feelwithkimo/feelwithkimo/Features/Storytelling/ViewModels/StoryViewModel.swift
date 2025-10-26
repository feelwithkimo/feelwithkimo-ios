//
//  StoryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation
import SwiftUI

internal class StoryViewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var currentScene: StorySceneModel = StorySceneModel(
        path: "",
        text: "",
        isEnd: false,
        interactionType: .normal
    )
    @Published var hasCompletedBreathing: Bool = false
    @Published var hasCompletedClapping: Bool = false

    lazy var story: StoryModel = StoryModel(
        id: UUID(),
        name: "Story Angry 1",
        thumbnail: "Thumbnail 1",
        description: "Description",
        storyScene: []
    )

    init() {
        Task { @MainActor in
            await self.fetchStory()
        }
    }

    /// Load story scene
    private func fetchStory() async {
        var scenes: [StorySceneModel] = []

        for number in 1...17 {
            scenes.append(StorySceneModel(
                path: "Scene \(number)",
                text: "",
                isEnd: false,
                interactionType: .normal
            ))
        }

        // Input previous Scene
        for number in 1...16 {
            scenes[number].nextScene.append(scenes[number - 1])
        }

        // Input next scene
        for number in 0...15 {
            scenes[number].nextScene.append(scenes[number + 1])
        }

        // Branching Question
        scenes[8].question = QuestionOption(
            question: "Jika Kamu jadi Lala, apa yang akan kamu lakukan?​",
            option: ["Cerita sama Ibu​", "Marah ke Ibu​"]
        )

        // Branch B Scene
        var branchBScene: [StorySceneModel] = []
        for number in 10...14 {
            branchBScene.append(StorySceneModel(
                path: "Scene \(number)_B",
                text: "",
                isEnd: false,
                interactionType: .normal
            ))
        }

        // Previous Scene for branch B
        for number in 1...4 {
            branchBScene[number].nextScene.append(branchBScene[number - 1])
        }
        branchBScene[0].nextScene.append(scenes[8])

        // Next Scene for branch B
        for number in 0...3 {
            branchBScene[number].nextScene.append(branchBScene[number + 1])
        }

        // Connect branching scene to branch B
        scenes[8].nextScene.append(branchBScene[0])

        scenes[16].isEnd = true // Branch A Ending
        branchBScene[4].isEnd = true // Branch B Ending
        
        scenes[7].interactionType = .storyBranching
        scenes[5].interactionType = .clapping
        scenes[13].interactionType = .breathing

        self.story.storyScene = scenes
        self.currentScene = self.story.storyScene[0]
    }

    /// Function to next and previous scene of story
    func goScene(to number: Int, choice: Int) {
        switch number {
        case 1:
            guard !self.currentScene.isEnd else { return }

            // Next scene for first scene since the first scene has no previous scene the index will be 0 instead of 1
            if self.currentScene.path == story.storyScene[0].path {
                self.currentScene = self.currentScene.nextScene[0]
            } else {
                self.currentScene = choice == 0 ? self.currentScene.nextScene[1] : self.currentScene.nextScene[2]
            }
            self.index += 1
        case -1:
            guard self.currentScene.nextScene.count > 1 else { return }

            withAnimation(.easeInOut(duration: 1.5)) { self.currentScene = self.currentScene.nextScene[0] }
            self.index -= 1
        default:
            break
        }
    }
    
    /// Mark breathing exercise as completed and move to next scene
    func completeBreathingExercise() {
        hasCompletedBreathing = true
        print("✅ Breathing exercise completed! Moving to next scene...")
        // Advance to the next scene when user presses "Lanjut" button
        goScene(to: 1, choice: 0)
        print("📖 Advanced to scene \(self.index + 1) after breathing completion")
    }

    /// Mark clapping exercise as completed
    func completeClappingExercise() {
        hasCompletedClapping = true
        goScene(to: 1, choice: 0)
        print("✅ Clapping exercise completed! Button text will change to 'Lanjut'")
    }
}
