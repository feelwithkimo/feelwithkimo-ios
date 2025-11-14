//
//  TutorialBubble.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 05/11/25.
//

import SwiftUI

struct TutorialBubble: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bacakan cerita ini untuk si kecil, ya!")
                .font(.customFont(size: 20, family: .primary, weight: .regular))
            
            Text("Gunakan suara dan ekspresi supaya si kecil ikut merasakannya")
                .font(.customFont(size: 20, family: .primary, weight: .regular))
        }
        .padding(.vertical, 24.getHeight())
        .padding(.horizontal, 15.getWidth())
        .background(ColorToken.corePinkDialogue.toColor())
        .cornerRadius(20)
    }
}
