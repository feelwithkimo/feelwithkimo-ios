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
        path: "Scene 1",
        text: "Hi aku Lala​",
        isEnd: false,
        interactionType: .normal
    )
    @Published var hasCompletedBreathing: Bool = false
    @Published var hasCompletedClapping: Bool = false
    @Published var isNavigatingForward: Bool = true
    
    /// Highest phase for the block game. When exceeded, it wraps back to 1.
    private let maxBlockGamePhase: Int = 2
    @Published var currentBlockGamePhase: Int = 1
    @Published var tutorialStep: Int = 1
    @Published var showDialogue: Bool = false
    @Published var quitStory: Bool = false
    
    var isTappedMascot: Bool = false

    var story: StoryModel = StoryModel(
        id: "Episode_1",
        name: "Story Angry 1",
        thumbnail: "Thumbnail 1",
        description: "Description",
        backsong: "Backsong_1",
        storyScene: []
    )
    
    init(story storyModel: StoryModel) {
        self.story = storyModel
        
        let locale = Locale.current

        var languageCode: String = locale.language.languageCode?.identifier ?? "id"
        
        // Special handling for Chinese
        if languageCode == "zh" {
            let scriptCode = locale.language.script?.identifier
            languageCode = scriptCode == "Hant" ? "zht" : "zh"
        }

        fetchStory(story: storyModel.id + "_\(languageCode)")
    }

    /// Load story scene
    private func fetchStory(story storyPath: String, defaultStoryPath: String = "Episode_1") {
        var storyScene: [StorySceneModel]! = JSONLoader.load([StorySceneModel].self, from: storyPath, fallback: defaultStoryPath)
        if storyScene == nil {
            storyScene = []
        }
        self.story.storyScene = storyScene
        self.currentScene = self.story.storyScene[0]
    }

    // MARK: - Public Methods
    
    /// Function to next and previous scene of story
    func goScene(to number: Int, choice: Int = 0) {
        switch number {
        case 1:
            goToNextScene(choice: choice)
        case -1:
            goToPreviousScene()
        default:
            break
        }
    }
    
    /// Navigate to next scene
    private func goToNextScene(choice: Int) {
        guard !currentScene.isEnd else { return }
        
        isNavigatingForward = true

        // Next scene for first scene
        if currentScene.path == story.storyScene[0].path {
            guard story.storyScene.count > 1 else { return }
            currentScene = story.storyScene[1]
        } else {
            let targetIndex = choice == 0 ? currentScene.nextScene[1] : currentScene.nextScene[2]
            guard story.storyScene.indices.contains(targetIndex) else {
                print("❌ Invalid scene index: \(targetIndex)")
                return
            }
            currentScene = story.storyScene[targetIndex]
        }
        
        showDialogue = false
        isTappedMascot = false
        index += 1
    }
    
    /// Navigate to previous scene
    private func goToPreviousScene() {
        guard currentScene.nextScene.count > 1 else { return }
        
        isNavigatingForward = false
        
        let previousIndex = currentScene.nextScene[0]
        guard story.storyScene.indices.contains(previousIndex) else {
            print("❌ Invalid previous scene index: \(previousIndex)")
            return
        }
        
        currentScene = story.storyScene[previousIndex]
        showDialogue = false
        isTappedMascot = false
        index -= 1
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
    
    /// Mark block game phase as completed and advance to next scene
    func completeBlockGamePhase() {
        if currentBlockGamePhase >= maxBlockGamePhase {
            currentBlockGamePhase = 1
        } else {
            currentBlockGamePhase += 1
        }
        goScene(to: 1, choice: 0)
    }
    
    /// Legacy function for compatibility - redirects to completeBlockGamePhase
    func completeBlockGame() {
        completeBlockGamePhase()
    }
  
    func replayStory() {
        DispatchQueue.main.async {
            self.index = 0
            if let firstScene = self.story.storyScene.first {
                self.currentScene = firstScene
            }
            self.hasCompletedBreathing = false
            self.hasCompletedClapping = false
            self.currentBlockGamePhase = 1
        }
    }
}
