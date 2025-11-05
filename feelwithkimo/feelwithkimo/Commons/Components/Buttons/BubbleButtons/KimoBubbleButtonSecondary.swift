//
//  KimoBubbleButtonSecondary.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct KimoBubbleButtonSecondary: View {
    var buttonLabel: String = "Coba Lagi"
    
    var body: some View {
        ZStack {
            Image("KimoBubbleButtonSecondary")
                .resizable()
                .scaledToFit()
                .frame(width: 253.getWidth(), height: 74.getHeight())
                .padding(0)
            
            Text(buttonLabel)
                .font(.app(.title1, family: .primary))
                .foregroundStyle(ColorToken.textPrimary.toColor())
                .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: 253.getWidth(), maxHeight: 74.getHeight())
        .cornerRadius(100)
    }
}

#Preview {
    KimoBubbleButtonSecondary()
}
