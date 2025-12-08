//
//  KimoTutorialCard.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 29/11/25.
//

import SwiftUI

struct KimoTutorialCard: View {
    let imageName: String
    let stepNumber: String
    let description: String
    let imageWidth: CGFloat
    let containetWidth: CGFloat

    var body: some View {
        VStack(spacing: 30.getHeight()) {
            KimoImage(image: imageName, width: imageWidth.getWidth())

            // MARK: Tutorial Body
            VStack(spacing: 10.getHeight()) {
                KimoCircleWrapper {
                    Text(stepNumber)
                        .font(.customFont(size: 22, weight: .bold))
                        .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                }
                
                Text(description)
                    .font(.customFont(size: 15, weight: .regular))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: containetWidth.getWidth())
    }
}

#Preview {
    HStack(spacing: 50.getWidth()) {
        KimoTutorialCard(imageName: "TutorialBlockFirst", stepNumber: "1", description: "Seret dan geser bentuk ke kotak yang sesuai.", imageWidth: 236, containetWidth: 236)
            .border(.red)
        
        KimoTutorialCard(imageName: "TutorialBlockSecond", stepNumber: "1", description: "Teruskan sampai bentuknya tersusun seperti contoh ini.", imageWidth: 100, containetWidth: 230)
            .border(.red)
    }
    .padding()
    .border(.blue)
}
