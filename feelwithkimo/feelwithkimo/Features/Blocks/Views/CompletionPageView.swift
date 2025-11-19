///
///  CompletionPageView.swift
///  feelwithkimo
///
///  Created on 14/11/25.
///

import SwiftUI

struct CompletionPageView: View {
    var title: String = "Tahap 1 Selesai!!!"
    var primaryButtonLabel: String = "Coba lagi"
    var secondaryButtonLabel: String = "Lanjutkan"
    var onPrimaryAction: (() -> Void)?
    var onSecondaryAction: (() -> Void)?
    
    @Environment(\.dismiss) var dismiss
    @State private var showOverlay = false
    @State private var showConfetti = false
    @State private var showCard = false
    @State private var showTitle = false
    @State private var showElephant = false
    @State private var showButtons = false
    
    var body: some View {
        ZStack {
            /// Black overlay with fade in animation
            Color.black.opacity(showOverlay ? 0.7 : 0)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 0.2), value: showOverlay)
            
            /// Completion card with animated components
            AnimatedCompletionCard(
                title: title,
                primaryButtonLabel: primaryButtonLabel,
                secondaryButtonLabel: secondaryButtonLabel,
                onPrimaryAction: onPrimaryAction,
                onSecondaryAction: onSecondaryAction,
                showCard: showCard,
                showTitle: showTitle,
                showElephant: showElephant,
                showButtons: showButtons
            )
            
            /// Confetti effect layer - on top of everything
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func startAnimationSequence() {
        /// 1. Show overlay and confetti immediately
        showOverlay = true
        showConfetti = true
        
        /// 2. Show card with all elements after 0.3s delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.showCard = true
                self.showTitle = true
                self.showElephant = true
                self.showButtons = true
            }
            
            /// 3. Play elephant sound when elephant appears (after the 0.3s delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                AudioManager.shared.playSoundEffect(effectName: "ElephantSoundEffect")
            }
        }
    }
}

// MARK: - Animated Completion Card Component
struct AnimatedCompletionCard: View {
    var title: String
    var primaryButtonLabel: String
    var secondaryButtonLabel: String
    var onPrimaryAction: (() -> Void)?
    var onSecondaryAction: (() -> Void)?
    
    var showCard: Bool
    var showTitle: Bool
    var showElephant: Bool
    var showButtons: Bool
    
    var body: some View {
        ZStack {
            /// White background card with borders - pops in with bounce
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .frame(width: 700.getWidth(), height: 620.getHeight())
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(ColorToken.coreAccent.toColor(), lineWidth: 14)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(
                            ColorToken.coreAccent.toColor(),
                            style: StrokeStyle(
                                lineWidth: 7,
                                dash: [40, 16]
                            )
                        )
                        .padding(20)
                )
                .scaleEffect(showCard ? 1.0 : 0.3)
                .opacity(showCard ? 1 : 0)
                .animation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0), value: showCard)
            
            /// Title and Buttons Layer
            VStack(spacing: 0) {
                /// Title bubble - slides from top with bounce
                ZStack {
                    /// Shadow layer (flatter, more elongated)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                        .offset(y: 12)
                    
                    /// Main title background (flatter elongated rounded rectangle)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ColorToken.emotionDisgusted.toColor())
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                    
                    Text(title)
                        .font(.customFont(size: 60, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .offset(y: showTitle ? -34.getHeight() : -200.getHeight())
                .opacity(showTitle ? 1 : 0)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showTitle)
                
                Spacer()
                
                /// Buttons - slide from bottom with fade
                HStack(spacing: 24.getWidth()) {
                    /// Primary button
                    KimoDialogueButton(
                        config: KimoDialogueButtonConfig(
                            title: primaryButtonLabel,
                            symbol: .arrowClockwise,
                            style: .bubbleSecondary,
                            action: {
                                onPrimaryAction?()
                            }
                        )
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.2), radius: 12, x: 0, y: 2)
                    
                    /// Secondary button
                    KimoDialogueButton(
                        config: KimoDialogueButtonConfig(
                            title: secondaryButtonLabel,
                            symbol: .chevronRight,
                            style: .bubbleSecondary,
                            action: {
                                onSecondaryAction?()
                            }
                        )
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .shadow(color: ColorToken.backgroundSecondary.toColor().opacity(0.2), radius: 12, x: 0, y: 2)
                }
                .offset(y: showButtons ? 0 : 100.getHeight())
                .opacity(showButtons ? 1 : 0)
                .animation(.easeOut(duration: 0.35), value: showButtons)
                .padding(.bottom, 50.getHeight())
            }
            
            /// Elephant image - bounces in with scale and slight jump
            Image("KimoSenang")
                .resizable()
                .scaledToFit()
                .frame(width: 460.getWidth(), height: 460.getHeight())
                .scaleEffect(showElephant ? 1.0 : 0)
                .offset(y: showElephant ? -50.getHeight() : 50.getHeight())
                .opacity(showElephant ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showElephant)
        }
        .frame(width: 700.getWidth(), height: 620.getHeight())
    }
}

#Preview {
    ZStack {
        /// Simulate game background
        BlocksGameView(level: .level1)
        
        /// Overlay the completion page
        CompletionPageView(
            onPrimaryAction: {
                print("Primary button tapped")
            },
            onSecondaryAction: {
                print("Secondary button tapped")
            }
        )
    }
}
