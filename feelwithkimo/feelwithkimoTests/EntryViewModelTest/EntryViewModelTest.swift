//
//  EntryViewModelTest.swift
//  EntryViewModelTest
//
//  Created by Richard Sugiharto on 29/11/25.
//

import Testing
import Combine
@testable import feelwithkimo

struct EntryViewModelTests {
    @Test("Loads story from provided JSON path")
    func loadsEmotionFromGivenPath() async throws {
        let viewModel = EntryViewModel(path: "Balok")
        let emotion = viewModel.emotion
        
        #expect(emotion.id == "Balok")
        #expect(emotion.title == "Bermain Balok")
    }
}
