//
//  TutorialView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 29/10/25.
//

import SwiftUI

struct TutorialView: View {
    @AppStorage("hasSeenTutorial") var seenTutorial = false
    @StateObject var viewModel: TutorialViewModel
    
    var body: some View {
        Image("Tutorial_\(viewModel.tutorialStep)")
            .resizable()
            .scaledToFill()
            .onTapGesture {
                if !viewModel.nextStep() {
                    seenTutorial = true
                }
            }
            .ignoresSafeArea()
    }
}
