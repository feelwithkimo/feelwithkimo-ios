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
        fetchStory(story: storyModel.id)
    }
    
    // MARK: - Private Helper Methods
    
    /// Determine localized suffix based on current locale
    private func getLocalizedSuffix() -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        
        // For Chinese, check both language region and script
        if languageCode == "zh" {
            let regionCode = Locale.current.region?.identifier ?? ""
            let scriptCode = Locale.current.language.script?.identifier ?? ""
            
            print("🔍 Debug - Language: \(languageCode), Region: \(regionCode), Script: \(scriptCode)")
            
            // Check script FIRST (more reliable for actual language variant)
            if scriptCode.lowercased().contains("hant") {
                return "_zht" // Traditional Chinese
            } else if scriptCode.lowercased().contains("hans") {
                return "_zhs" // Simplified Chinese
            }
            
            // Fallback to region check if script is not available
            if regionCode == "TW" || regionCode == "HK" || regionCode == "MO" {
                return "_zht" // Traditional Chinese
            } else if regionCode == "CN" || regionCode == "SG" {
                return "_zhs" // Simplified Chinese
            }
            
            // Default to Simplified if we can't determine
            return "_zhs"
        }
        
        if languageCode == "en" {
            return "_en"
        }
        
        return "_id"
    }

    /// Find URL for story JSON file with fallback logic
    private func findStoryURL(for storyPath: String, suffix: String) -> URL? {
        // Attempt 1: Try specific language (e.g., "Episode_1_zhs")
        var finalPath = "\(storyPath)\(suffix)"
        if let url = Bundle.main.url(forResource: finalPath, withExtension: "json") {
            print("✅ Found: \(finalPath).json")
            return url
        }
        
        // Attempt 2: For Chinese variants, try alternate Chinese version
        print("⚠️ \(finalPath).json not found.")
        if suffix == "_zht" {
            print("   Trying Simplified Chinese fallback...")
            finalPath = "\(storyPath)_zhs"
            if let url = Bundle.main.url(forResource: finalPath, withExtension: "json") {
                print("✅ Found fallback: \(finalPath).json")
                return url
            }
        } else if suffix == "_zhs" {
            print("   Trying Traditional Chinese fallback...")
            finalPath = "\(storyPath)_zht"
            if let url = Bundle.main.url(forResource: finalPath, withExtension: "json") {
                print("✅ Found fallback: \(finalPath).json")
                return url
            }
        }
        
        // Attempt 3: Try English fallback
        print("   Trying English fallback...")
        finalPath = "\(storyPath)_en"
        if let url = Bundle.main.url(forResource: finalPath, withExtension: "json") {
            print("✅ Found fallback: \(finalPath).json")
            return url
        }
        
        // Attempt 4: Try Indonesian fallback
        print("   Trying Indonesian fallback...")
        finalPath = "\(storyPath)_id"
        if let url = Bundle.main.url(forResource: finalPath, withExtension: "json") {
            print("✅ Found fallback: \(finalPath).json")
            return url
        }
        
        // Attempt 5: Try base filename
        print("   Trying base file: \(storyPath)...")
        return Bundle.main.url(forResource: storyPath, withExtension: "json")
    }
    
    /// Log available story files in bundle
    private func logAvailableFiles(for storyPath: String) {
        print("❌ CRITICAL ERROR: Could not find ANY version of \(storyPath) in Bundle.")
        print("📦 Available files in Bundle:")
        if let resourcePath = Bundle.main.resourcePath {
            let contents = try? FileManager.default.contentsOfDirectory(atPath: resourcePath)
            contents?.filter { $0.contains(storyPath) }.forEach { print("   - \($0)") }
        }
    }
    
    /// Log detailed decoding error information
    private func logDecodingError(_ error: Error, fileName: String) {
        print("❌ Failed to decode \(fileName):")
        print("   Error: \(error)")
        
        guard let decodingError = error as? DecodingError else { return }
        
        switch decodingError {
        case .keyNotFound(let key, let context):
            print("   Missing key: \(key.stringValue) - \(context.debugDescription)")
        case .typeMismatch(let type, let context):
            print("   Type mismatch: \(type) - \(context.debugDescription)")
        case .valueNotFound(let type, let context):
            print("   Value not found: \(type) - \(context.debugDescription)")
        case .dataCorrupted(let context):
            print("   Data corrupted: \(context.debugDescription)")
        @unknown default:
            print("   Unknown decoding error")
        }
    }
    
    /// Update story scenes on main thread
    private func updateStoryScenes(_ scenes: [StorySceneModel], fileName: String) {
        DispatchQueue.main.async {
            self.story.storyScene = scenes
            
            if let firstScene = scenes.first {
                self.currentScene = firstScene
                print("✅ Successfully loaded: \(fileName) with \(scenes.count) scenes")
            } else {
                print("⚠️ Loaded \(fileName) but the scene list is empty!")
            }
        }
    }
    
    /// Load story scene
    private func fetchStory(story storyPath: String = "Episode_1") {
        // Files that don't need localization
        let nonLocalizedFiles = ["Balok", "LalaInBlockGame"]
        
        // Check if this file should skip localization
        if nonLocalizedFiles.contains(storyPath) {
            print("📦 Loading non-localized file: \(storyPath).json")
            guard let url = Bundle.main.url(forResource: storyPath, withExtension: "json") else {
                print("❌ File not found: \(storyPath).json")
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let scenes = try decoder.decode([StorySceneModel].self, from: data)
                updateStoryScenes(scenes, fileName: url.lastPathComponent)
            } catch {
                logDecodingError(error, fileName: url.lastPathComponent)
            }
            return
        }
        
        // Continue with localization for other files
        let localizedSuffix = getLocalizedSuffix()
        
        print("🌍 Detected language suffix: \(localizedSuffix)")
        print("📁 Looking for: \(storyPath)\(localizedSuffix).json")
        
        guard let validUrl = findStoryURL(for: storyPath, suffix: localizedSuffix) else {
            logAvailableFiles(for: storyPath)
            return
        }
        
        do {
            let data = try Data(contentsOf: validUrl)
            let decoder = JSONDecoder()
            let scenes = try decoder.decode([StorySceneModel].self, from: data)
            
            updateStoryScenes(scenes, fileName: validUrl.lastPathComponent)
        } catch {
            logDecodingError(error, fileName: validUrl.lastPathComponent)
        }
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
