//
//  KimoInteractionTutorialWrapper.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/11/25.
//

import SwiftUI

struct KimoInteractionTutorialWrapper<Content: View>: View {
    let title: String
    let quotePrefix: String
    let quoteBody: String
    let action: (() -> Void)?
    var cornerRadius: CGFloat = 30
    private let headerOffset: CGFloat = 44.getHeight()
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            
            headerView
                .padding(.top, headerOffset)
            
            VStack {
                Spacer()

                ZStack(alignment: .top) {

                    mainBubble

                    floatingTitle
                    .offset(y: -35.getHeight())
                }

                Spacer()
            }
            .padding(.top, headerOffset)
        }
        .ignoresSafeArea()
    }
}
private extension KimoInteractionTutorialWrapper {
    var mainBubble: some View {
        VStack {
            bubbleContent
        }
        .padding(.horizontal, 26.getWidth())
        .padding(.vertical, 26.getHeight())
        .background(
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(ColorToken.coreAccent.toColor(), lineWidth: 15.getWidth())
        )
    }

    var bubbleContent: some View {
        VStack {
            VStack(spacing: 40.getHeight()) {
                content

                quoteView
            }
            .padding(.top, 59.getHeight())
            .padding(.bottom, 58.getHeight())
            .padding(.horizontal, 51.getWidth())
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        ColorToken.coreAccent.toColor(),
                        style: StrokeStyle(
                            lineWidth: 7.getWidth(),
                            dash: [40, 16]
                        )
                    )
            )
        }
    }

    var quoteView: some View {
        (Text(quotePrefix)
            .font(.customFont(size: 17, family: .primary, weight: .bold))
        +
        Text(quoteBody)
            .font(.customFont(size: 17, family: .primary, weight: .regular)))
        .foregroundStyle(ColorToken.backgroundSecondary.toColor())
        .lineLimit(3)
        .frame(width: 604.getWidth())
        .multilineTextAlignment(.center)
    }
        
    var headerView: some View {
        VStack {
            HStack {
                KimoCloseButton(isLarge: false, action: action)
                Spacer()
            }
            .padding(.horizontal, 55.getWidth())
            .padding(.top, headerOffset)
            
            Spacer()
        }
    }

    var floatingTitle: some View {
        return HStack {
                Text(title)
                    .padding(.horizontal, 10)
                    .font(.customFont(size: 34, weight: .bold))
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            .padding(.horizontal, 58.getWidth())
            .padding(.vertical, 24.getHeight())
            .background(
                ColorToken.emotionSadness.toColor()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .shadow(color: ColorToken.emotionDisgusted.toColor(), radius: 3, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(ColorToken.backgroundIdentity.toColor(), lineWidth: 8.getWidth())
            )
    }
}

#Preview {
    KimoInteractionTutorialWrapper(
        title: "Cara Bermain",
        quotePrefix: "Menurut Dokter Weil, ",
        quoteBody: "Latihan pernapasan ini membantu menenangkan sistem saraf secara alami. " +
                    "Semakin rutin dilakukan, semakin mudah anak mengatur rasa cemas dan menenangkan tubuhnya.",
        action: {},
        content: {
            VStack {
                ForEach(0..<5) {_ in
                    Text("Test")
                }
            }
        }
    )
}
