//
//  IdentityViewModels.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation
import SwiftUI

internal class IdentityViewModel: ObservableObject {
    @AppStorage("parentNickname") var parentNickname: String = ""
    @AppStorage("identity") var identity: String = ""

    @Published var nicknameInput: String = ""
    @Published var childNicknameInput: String = ""
    @Published var showError: Bool = false
    @Published var navigateToChild: Bool = false

    var alertMessage: String = ""

    // Function to submit nickname of parent
    func submitNickname() {
        let trimmed = nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            showError = true
            return
        }

        showError = false
        navigateToChild = true
    }
    
    func submitName() {
        let trimmed = childNicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            alertMessage = "Nama anak tidak boleh kosong"
            showError = true
            return
        }
        
        let trimmedParent = nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedParent.isEmpty else {
            alertMessage = "Nama panggilan tidak boleh kosong"
            showError = true
            return
        }

        identity = trimmed
        parentNickname = trimmedParent
        showError = false
    }
}
