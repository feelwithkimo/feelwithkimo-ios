//
//  StoryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation
import SwiftUI

internal class StoryViewModel: ObservableObject {
    @AppStorage("hasSeenTutorial") var hasSeenTutorial = false
    @Published var hasSeenTutor: Bool = false
    
    @Published var index: Int = 0
    @Published var currentScene: StorySceneModel = StorySceneModel(
        path: "Scene 1",
        text: "Hi aku Lala​",
        isEnd: false,
        interactionType: .normal
    )
    @Published var hasCompletedBreathing: Bool = false
    @Published var hasCompletedClapping: Bool = false
    @Published var tutorialStep: Int = 1
    
    @Published var showDialogue: Bool = false
    var isTappedMascot: Bool = false

    lazy var story: StoryModel = StoryModel(
        id: "Episode_1",
        name: "Story Angry 1",
        thumbnail: "Thumbnail 1",
        description: "Description",
        backsong: "Backsong_1",
        storyScene: []
    )

    init(story storyModel: StoryModel) {
        self.story = storyModel
        fetchStory(story: storyModel.id)
    }

    /// Load story scene
    private func fetchStory(story storyPath: String = "Episode_1") {
        guard let url = Bundle.main.url(forResource: storyPath, withExtension: "json") else {
            print("❌ \(storyPath).json not found in bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let scenes = try decoder.decode([StorySceneModel].self, from: data)
            
            // Assign to your properties
            self.story.storyScene = scenes
            self.currentScene = self.story.storyScene[0]
        } catch {
            print("❌ Failed to load story.json:", error)
        }
    }

    /// Function to next and previous scene of story
    func goScene(to number: Int, choice: Int = 0) {
        switch number {
        case 1:
            guard !self.currentScene.isEnd else { return }

            // Next scene for first scene since the first scene has no previous scene the index will be 0 instead of 1
            if self.currentScene.path == story.storyScene[0].path {
                self.currentScene = self.story.storyScene[1]
            } else {
                self.currentScene = choice == 0 ? self.story.storyScene[self.currentScene.nextScene[1]] : self.story.storyScene[self.currentScene.nextScene[2]]
            }
            self.showDialogue = false
            self.isTappedMascot = false
            self.index += 1
            
        // Previous Scene
        case -1:
            guard self.currentScene.nextScene.count > 1 else { return }

            self.currentScene = self.story.storyScene[self.currentScene.nextScene[0]]
            self.showDialogue = false
            self.isTappedMascot = false
            self.index -= 1
        default:
            break
        }
    }
    
    /// Mark breathing exercise as completed and move to next scene
    func completeBreathingExercise() {
        hasCompletedBreathing = true
        goScene(to: 1, choice: 0)
    }

    /// Mark clapping exercise as completed
    func completeClappingExercise() {
        hasCompletedClapping = true
        goScene(to: 1, choice: 0)
    }
    
    func nextTutorial() {
        guard self.tutorialStep < 1 else {
            DispatchQueue.main.async {
                self.hasSeenTutorial = true
                self.hasSeenTutor = true
            }
            return
        }
        
        DispatchQueue.main.async {
            self.tutorialStep += 1
        }
    }
  
    func replayStory() {
        DispatchQueue.main.async {
            self.index = 0
            self.currentScene = self.story.storyScene[0]
            self.hasCompletedBreathing = false
            self.hasCompletedClapping = false
        }
    }
}
