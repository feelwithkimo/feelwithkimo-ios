//
//  IdentityViewModels.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI
import Foundation

class IdentityViewModel: ObservableObject {
    @AppStorage("parentNickname") var parentNickname: String = ""
    @AppStorage("identity") var identity: String = ""

    @Published var nicknameInput: String = ""
    @Published var showError: Bool = false
    @Published var navigateToChild: Bool = false
    @Published var childName: String = ""

    var alertMessage: String = ""

    // Function to submit nickname of parent
    func submitNickname() {
        let trimmed = nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            showError = true
            return
        }

        parentNickname = trimmed
        showError = false
        navigateToChild = true
    }

    func submitChildName() -> Bool {
        let trimmed = childName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            alertMessage = "Nama tidak boleh kosong"
            showError = true
            return false
        }

        identity = trimmed
        showError = false
        return true
    }
}
