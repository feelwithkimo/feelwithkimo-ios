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

    var errorMessageChild: String = "Lengkapi dulu nama Si Kecil, ya!"
    var errorMessageNickname: String = "Isi dulu panggilan Ayah/Ibu, ya."
    @Published var showErrorChild: Bool = false
    @Published var showErrorNickname: Bool = false
    
    // Function to submit nickname of parent
    func submitName() {
        let trimmed = childNicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedParent = nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        showErrorChild = trimmed.isEmpty
        showErrorNickname = trimmedParent.isEmpty
        
        guard !showErrorChild && !showErrorNickname else {
            return
        }
        
        identity = trimmed
        parentNickname = trimmedParent
    }
}
