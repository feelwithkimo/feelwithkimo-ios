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
        
        fetchStory(story: "\(storyModel.id)_\(languageCode)")
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
