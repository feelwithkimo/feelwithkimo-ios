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
    let mark: KimoVisual
    
    @Environment(\.dismiss) var dismiss
    @Binding var showDialogue: Bool
    @Binding var isMascotTapped: Bool
    
    private let animationDuration: Double = 0.3
    private let textDialogue: String = "KimoAskTextDialogue"
    
    // MARK: - Initializers
    init(
        dialogueText: String = NSLocalizedString("Lets_Start", comment: ""),
        dialogueIcon: String = "Kimo",
        textDialogueLeft: String = "TextDialogueLeft",
        titleText: String = "Title",
        bodyText: String = "Body",
        mark: KimoVisual = .normal,
        showDialogue: Binding<Bool>,
        isMascotTapped: Binding<Bool>
    ) {
        self.customDialogueText = dialogueText
        self.dialogueIcon = dialogueIcon
        self.textDialogueLeft = textDialogueLeft
        self.titleText = titleText
        self.bodyText = bodyText
        self.mark = mark
        self._showDialogue = showDialogue
        self._isMascotTapped = isMascotTapped
    }
    
    var body: some View {
        ZStack {
            // Mascot positioned in bottom right
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    ZStack(alignment: .topTrailing) {
                        if showDialogue {
                            dialogue
                                .padding(.top)
                                .padding(.trailing, 100.getWidth())
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .trailing).combined(with: .opacity)
                                    )
                                )
                            
                        }
                        
                        Button(action: {
                            toggleMascot()
                        }, label: {
                            KimoImage(image: "KimoVisual", width: 105.getWidth())
                                .scaleEffect(showDialogue ? 1.2 : 1)
                        })
                        .kimoButtonAccessibility(
                            label: "Kimo maskot kecil",
                            hint: "Ketuk dua kali untuk berinteraksi dengan Kimo",
                            identifier: "breathing.kimoMascot"
                        )
                        .padding(.trailing, 32.getWidth())
                        .padding(.top, 14.getHeight())
                        .padding(.bottom, 253.getHeight())
                        
                        VStack {
                            switch mark {
                            case .mark:
                                KimoImage(image: "ExclamationMark", width: 20.getWidth())
                                    .padding(.trailing, 45.getWidth())
                                    .scaleEffect(showDialogue ? 1.2 : 1)
                                
                            case .star:
                                HStack {
                                    Spacer()
                                    KimoImage(image: "Star", width: 45.getWidth())
                                        .padding(.trailing, 14.getWidth())
                                        .scaleEffect(showDialogue ? 1.2 : 1)
                                }
                                
                            default:
                                EmptyView()
                            }
                            
                            Spacer()
                                .frame(height: 303.getHeight())
                        }
                        .padding(0)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: animationDuration), value: showDialogue)
    }
    
    // MARK: - Mascot Functions
    private func toggleMascot() {
        guard mark != .normal else {
            self.showDialogue = false
            AudioManager.shared.playSoundEffect(effectName: "ElephantSoundEffect")
            return
        }
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            if isMascotTapped {
                // Hide dialogue and reset mascot
                showDialogue = false
                isMascotTapped = false
            } else {
                // Show dialogue and scale mascot
                showDialogue = true
                isMascotTapped = true
            }
        }
    }
    
    // MARK: - Dialogue Views
    private var dialogue: some View {
        HStack(spacing: -2) {
            HStack {
                    Text(customDialogueText)
                        .font(.customFont(size: 16, family: .primary, weight: .regular))
                        .foregroundColor(ColorToken.additionalColorsBlack.toColor())
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 27.getWidth())
                .padding(.vertical, 30.getHeight())
                .background(ColorToken.corePinkDialogue.toColor())
                .cornerRadius(28)
                .frame(
                    maxWidth: UIScreen.main.bounds.width * 0.5,
                    alignment: .leading
                )
                .fixedSize(horizontal: true, vertical: false)
            
            Image(textDialogue)
                .resizable()
                .scaledToFit()
                .frame(width: 41.getWidth(), height: 29.getHeight())
                .padding(.trailing, 60)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Default dialogue
//        KimoAskView()
        
//        // Custom dialogue for story pages
//        KimoAskView(dialogueText: "Ayo kita lanjutkan ceritanya!")
//        
//        // Another example for breathing exercise
//        KimoAskView(dialogueText: "Tarik nafas dalam-dalam dan rasakan ketenangan")
    }
    .background(Color.gray.opacity(0.1))
}
