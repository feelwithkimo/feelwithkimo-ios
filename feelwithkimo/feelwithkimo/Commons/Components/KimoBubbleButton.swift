//
//  KimoBubbleButton.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 04/11/25.
//

import SwiftUI

struct KimoBubbleButton: View {
    var buttonLabel: String = "Ayo Mulai!"
    
    var body: some View {
        ZStack {
            Image("KimoBubbleButton")
                .resizable()
                .scaledToFit()
                .frame(width: 253.getWidth())
                .padding(0)
            
            Text(buttonLabel)
                .font(.app(.title1, family: .primary))
                .foregroundStyle(Color.white)
                .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 253.getWidth())
        .cornerRadius(100)
    }
}

#Preview {
    KimoBubbleButton()
}
