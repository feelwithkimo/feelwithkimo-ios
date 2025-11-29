//
//  KimoQuestionButton.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 28/11/25.
//

import SwiftUI

struct KimoQuestionButton: View {
    var isLarge: Bool = false
    var action: (() -> Void)?
    
    var width: CGFloat {
        return isLarge ? 120.getWidth() : 80.getWidth()
    }
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            KimoImage(
                image: "Question",
                width: width
            )
        }
    )}
}
