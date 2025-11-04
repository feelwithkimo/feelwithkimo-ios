//
//  TutorialViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 29/10/25.
//

import Foundation

internal class TutorialViewModel: ObservableObject {
    @Published var tutorialStep: Int = 1
    
    func nextStep() -> Bool {
        guard tutorialStep < 3 else { return false }
        
        tutorialStep += 1
        return true
    }
}
