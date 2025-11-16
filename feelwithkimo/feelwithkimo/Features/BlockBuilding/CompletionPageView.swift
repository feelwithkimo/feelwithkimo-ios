//
//  CompletionPageView.swift
//  feelwithkimo
//
//  Created on 14/11/25.
//

import SwiftUI

struct CompletionPageView<Background: View>: View {
    var title: String = "Tahap 1 Selesai!!!"
    var primaryButtonLabel: String = "Coba lagi"
    var secondaryButtonLabel: String = "Lanjutkan"
    var onPrimaryAction: (() -> Void)?
    var onSecondaryAction: (() -> Void)?
    var background: () -> Background
    
    @State private var showOverlay = false
    @State private var showConfetti = false
    @State private var showCard = false
    @State private var showTitle = false
    @State private var showElephant = false
    @State private var showButtons = false
    
    var body: some View {
        ZStack {
            // Background view (the game itself)
            background()
            
            // Black overlay with fade in animation
            Color.black.opacity(showOverlay ? 0.7 : 0)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 0.3), value: showOverlay)
            
            // Confetti effect layer - appears early
            if showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
            
            // Completion card with animated components
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
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func startAnimationSequence() {
        // 1. Fade in overlay (0.0s)
        withAnimation {
            showOverlay = true
        }
        
        // 2. Show confetti ribbons (0.15s) - slightly earlier
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            showConfetti = true
        }
        
        // 3. Pop in card with bounce (0.25s) - slightly earlier
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            showCard = true
        }
        
        // 4. Slide in title from top (0.4s) - earlier
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showTitle = true
        }
        
        // 5. Bounce in elephant with scale (0.45s) - much earlier, almost with title
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            showElephant = true
            AudioManager.shared.playSoundEffect(effectName: "ElephantSoundEffect")
        }
        
        // 6. Slide up buttons from bottom (0.65s) - earlier
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            showButtons = true
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
            // White background card with borders - pops in with bounce
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
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0), value: showCard)
            
            // Title and Buttons Layer
            VStack(spacing: 0) {
                // Title bubble - slides from top with bounce
                ZStack {
                    // Shadow layer
                    RoundedRectangle(cornerRadius: 50)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                        .offset(y: 5)
                    
                    // Main title background
                    RoundedRectangle(cornerRadius: 50)
                        .fill(ColorToken.coreAccent.toColor())
                        .frame(width: 520.getWidth(), height: 68.getHeight())
                    
                    Text(title)
                        .font(.app(size: 40, family: .primary, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .offset(y: showTitle ? -34.getHeight() : -200.getHeight())
                .opacity(showTitle ? 1 : 0)
                .animation(.spring(response: 0.45, dampingFraction: 0.75), value: showTitle)
                
                Spacer()
                
                // Buttons - slide from bottom with fade
                HStack(spacing: 24.getWidth()) {
                    // Primary button
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
                    
                    // Secondary button
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
            
            // Elephant image - bounces in with scale and slight jump
            Image("KimoSenang")
                .resizable()
                .scaledToFit()
                .frame(width: 460.getWidth(), height: 460.getHeight())
                .scaleEffect(showElephant ? 1.0 : 0)
                .offset(y: showElephant ? -50.getHeight() : 50.getHeight())
                .opacity(showElephant ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.65), value: showElephant)
        }
        .frame(width: 700.getWidth(), height: 620.getHeight())
    }
}

#Preview {
    CompletionPageView(
        onPrimaryAction: {
            print("Primary button tapped")
        },
        onSecondaryAction: {
            print("Secondary button tapped")
        },
        background: {
            BlocksGameView(level: .level1)
        }
    )
}
