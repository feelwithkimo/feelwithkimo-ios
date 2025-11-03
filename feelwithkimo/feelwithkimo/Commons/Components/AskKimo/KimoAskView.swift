//
//  KimoAskView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 03/11/25.
//

import SwiftUI

struct KimoAskView: View {
    // Customizable properties
    let customDialogueText: String
    let dialogueIcon: String
    let textDialogueLeft: String
    let titleText: String
    let bodyText: String
    
    @State private var kimoMascotScale: CGFloat = 1.0
    @State private var isMascotTapped: Bool = false
    @State private var showDialogue: Bool = false
    @Environment(\.dismiss) var dismiss
    
    private let animationDuration: Double = 0.3
    private let textDialogue: String = "KimoAskTextDialogue"
    
    // MARK: - Initializers
    init(
        dialogueText: String = "Kimo Goblok Kimo Goblok Kimo Goblok Kimo Goblok",
        dialogueIcon: String = "Kimo",
        textDialogueLeft: String = "TextDialogueLeft",
        titleText: String = "Title",
        bodyText: String = "Body"
    ) {
        self.customDialogueText = dialogueText
        self.dialogueIcon = dialogueIcon
        self.textDialogueLeft = textDialogueLeft
        self.titleText = titleText
        self.bodyText = bodyText
    }
    
    var body: some View {
        ZStack {
            // Dialogue positioned above mascot
            if showDialogue {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        dialogue
                            .padding(.trailing, 30)
                            .padding(.bottom, 180)
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    )
                )
            }
            
            // Mascot positioned in bottom right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        toggleMascot()
                    }, label: {
                        Image("Kimo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .scaleEffect(kimoMascotScale)
                    })
                    .kimoButtonAccessibility(
                        label: "Kimo maskot kecil",
                        hint: "Ketuk dua kali untuk berinteraksi dengan Kimo",
                        identifier: "breathing.kimoMascot"
                    )
                    .padding(.trailing, 30)
                    .padding(.bottom, 200)
                }
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: showDialogue)
    }
    
    // MARK: - Mascot Functions
    private func toggleMascot() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            if isMascotTapped {
                // Hide dialogue and reset mascot
                showDialogue = false
                kimoMascotScale = 1.0
                isMascotTapped = false
            } else {
                // Show dialogue and scale mascot
                showDialogue = true
                kimoMascotScale = 1.2
                isMascotTapped = true
                
                // Auto-hide dialogue after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        showDialogue = false
                        kimoMascotScale = 1.0
                        isMascotTapped = false
                    }
                }
            }
        }
    }
    
    // MARK: - Dialogue Views
    private var dialogue: some View {
        HStack(spacing: -2) {
            HStack {
                Text(customDialogueText)
                    .font(.app(.title3, family: .primary))
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .frame(maxWidth: 300, alignment: .leading)
            .padding(.horizontal, 27 * UIScreen.main.bounds.width / 1194)
            .padding(.vertical, 30 * UIScreen.main.bounds.height / 834)
            .background(ColorToken.corePinkDialogue.toColor())
            
            Image(textDialogue)
                .resizable()
                .scaledToFit()
                .frame(width: 40.84 * UIScreen.main.bounds.width / 1194,
                       height: 29.14 * UIScreen.main.bounds.height / 834)
                .padding(.trailing, 60)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default dialogue
        KimoAskView()
        
//        // Custom dialogue for story pages
//        KimoAskView(dialogueText: "Ayo kita lanjutkan ceritanya!")
//        
//        // Another example for breathing exercise
//        KimoAskView(dialogueText: "Tarik nafas dalam-dalam dan rasakan ketenangan")
    }
    .background(Color.gray.opacity(0.1))
}
