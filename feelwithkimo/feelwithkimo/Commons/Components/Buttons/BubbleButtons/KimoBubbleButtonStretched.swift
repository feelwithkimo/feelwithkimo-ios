//
//  KimoBubbleButtonStretched.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct KimoBubbleButtonStretched: View {
    var buttonLabel: String = "Menendang balok-baloknya"
    
    var body: some View {
        ZStack {
            Image("KimoBubbleButtonStretched")
                .resizable()
                .scaledToFit()
                .frame(width: 442.getWidth(), height: 74.getHeight())
                .padding(0)
            
            Text(buttonLabel)
                .font(.app(.title1, family: .primary))
                .foregroundStyle(ColorToken.textPrimary.toColor())
                .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 442.getWidth(), maxHeight: 74.getHeight())
        .cornerRadius(100)
    }
}

#Preview {
    KimoBubbleButtonStretched()
}
