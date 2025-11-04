//
//  BreathingViewMidfi.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 30/10/25.
//
import SwiftUI

struct BreathingModuleView: View {
    @StateObject private var viewModel = BreathingModuleViewModel()
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @Environment(\.dismiss) var dismiss
    var onCompletion: (() -> Void)?
    
    // MARK: - Public Initializer
    public init(onCompletion: (() -> Void)? = nil) {
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        ZStack {
            // Main breathing view
            mainBreathingView
            
            // Completion overlay
            if viewModel.showCompletionView {
                completionView
            }
        }
        .onAppear {
            viewModel.onCompletion = onCompletion
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman latihan pernafasan. Ikuti instruksi Kimo untuk bernapas dengan tenang.")
            }
        }
        .onDisappear {
            viewModel.stopBreathing()
            audioManager.isMuted = false
        }
    }
    
    // MARK: - Main Breathing View
    private var mainBreathingView: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ColorToken.additionalColorsWhite.toColor()
                    .ignoresSafeArea()
                
                // Current phase - top left, fixed position
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center, spacing: geometry.size.width * 0.05) {
                        Text(viewModel.currentPhase.rawValue)
                            .font(Font(
                                UIFont.appFont(
                                    size: geometry.size.width * 0.06,
                                    family: .primary,
                                    weight: .bold
                                )
                            ))
                            .foregroundColor(ColorToken.textBreathing.toColor())
                            .multilineTextAlignment(.leading)
                            .lineSpacing(0)
                            .padding(.leading, geometry.size.width * 0.05)
                            .padding(.top, geometry.safeAreaInsets.top + 100)
                            .kimoTextAccessibility(
                                label: "Latihan Pernafasan Tarik Nafas",
                                identifier: "breathing.title",
                                sortPriority: 1
                            )
                        
                        Spacer()
                    }
                    Spacer()
                }
                
                // Timer circle - top right, fixed position
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(ColorToken.backgroundBreathing.toColor())
                                .frame(width: geometry.size.width * 0.12, 
                                       height: geometry.size.width * 0.12)
                            
                            Text("\(viewModel.remainingTime) detik")
                                .font(Font(
                                    UIFont.appFont(
                                        size: geometry.size.width * 0.025,
                                        family: .primary,
                                        weight: .bold
                                    )
                                ))
                                .foregroundColor(ColorToken.textBreathing.toColor())
                        }
                        .padding(.trailing, geometry.size.width * 0.06)
                        .padding(.top, geometry.safeAreaInsets.top + 120)
                    }
                    Spacer()
                }
                .kimoTextGroupAccessibility(
                    combinedLabel: "Instruksi pernapasan: \(viewModel.currentPhase.rawValue). Waktu tersisa: \(viewModel.remainingTime) detik.",
                    identifier: "breathing.instruction",
                    sortPriority: 2
                )
                
                // Center breathing animation
                mascotAnimation
                
                // Bottom section - cycle indicator and button, fixed position
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        if !viewModel.isActive {
                            Button(action: {
                                viewModel.startBreathing()
                                accessibilityManager.announce("Latihan pernapasan dimulai. Ikuti instruksi Kimo")
                            }, label: {
                                Text("Mulai")
                                    .font(.app(.title1, family: .primary))
                                    .foregroundColor(ColorToken.textPrimary.toColor())
                                    .padding(.horizontal, geometry.size.width * 0.035)
                                    .padding(.vertical, 14)
                                    .background(ColorToken.textBreathing.toColor())
                                    .cornerRadius(30)
                            })
                            .kimoButtonAccessibility(
                                label: "Mulai latihan pernapasan",
                                hint: "Ketuk dua kali untuk memulai latihan pernapasan bersama Kimo",
                                identifier: "breathing.startButton"
                            )
                        } else {
                            HStack(spacing: 20) {
                                // Cycle indicator - show when active
                                Text("Latihan Tarik Nafas \(viewModel.cycleCount)/3")
                                    .font(.app(.title2, family: .primary))
                                    .foregroundColor(ColorToken.textPrimary.toColor())
                                    .padding(.horizontal, geometry.size.width * 0.035)
                                    .padding(.vertical, 16)
                                    .background(ColorToken.backgroundSecondary.toColor())
                                    .cornerRadius(30)
                                
                                // Stop Button
                                Button(action: {
                                    viewModel.isActive = false
                                    viewModel.stopBreathing()
                                }, label: {
                                    Text("Berhenti")
                                        .font(.app(.title1, family: .primary))
                                        .foregroundColor(ColorToken.textBreathing.toColor())
                                        .padding(.horizontal, geometry.size.width * 0.035)
                                        .padding(.vertical, 14)
                                        .background(ColorToken.backgroundBreathing.toColor())
                                        .cornerRadius(30)
                                })
                            }
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
                }
                
                // Small Kimo mascot - bottom right, fixed position
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        KimoAskView()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Breathing Mascot Animation
    private var mascotAnimation: some View {
        // Breathing animation circle - centered
        ZStack {
            // Background breathing circles
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(
                              RadialGradient(
                                  colors: [
                                    ColorToken.coreLightPrimary.toColor().opacity(1.0),
                                    ColorToken.coreLightPrimary.toColor().opacity(0.4),
                                    ColorToken.coreLightPrimary.toColor().opacity(0.3),
                                    ColorToken.coreLightPrimary.toColor().opacity(0.2)
                                  ],
                                  center: .center,
                                  startRadius: 0,
                                  endRadius: (viewModel.startAnimation ? 400 : 200) + CGFloat(index * 50)
                              )
                          )
                        .frame(width: viewModel.startAnimation ? 400 + CGFloat(index * 50) : 200 + CGFloat(index * 30),
                               height: viewModel.startAnimation ? 400 + CGFloat(index * 50) : 200 + CGFloat(index * 30))
                        .animation(.easeInOut(duration: 3).delay(Double(index) * 0.2), value: viewModel.startAnimation)
                }
            }
            
            // Kimo Mascot
            Image(viewModel.currentPhase.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 350)
                .scaleEffect(viewModel.animationScale)
                .animation(.easeInOut(duration: viewModel.currentPhase.duration), value: viewModel.animationScale)
                .kimoImageAccessibility(
                    label: "Kimo sedang bernapas, \(viewModel.currentPhase.rawValue), ikuti gerakan Kimo",
                    isDecorative: false,
                    identifier: "breathing.kimoAnimation"
                )
        }
    }
    
    // MARK: - Completion View
    private var completionView: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            KimoDialogueView(
                textDialogue: "Hore.. kamu berhasil tarik nafas",
                buttonLayout: .horizontal([
                    KimoDialogueButtonConfig(
                        title: "Coba lagi",
                        symbol: .arrowClockwise,
                        backgroundColor: ColorToken.emotionSurprise.toColor(),
                        foregroundColor: ColorToken.textPrimary.toColor(),
                        action: {
                            viewModel.restartBreathing()
                        }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Lanjutkan",
                        symbol: .chevronRight,
                        backgroundColor: ColorToken.emotionSurprise.toColor(),
                        foregroundColor: ColorToken.textPrimary.toColor(),
                        action: {
                            dismiss()
                        }
                    )
                ])
            )
        }
    }
}

#Preview {
    BreathingModuleView(onCompletion: {
        print("Breathing exercise completed")
    })
}
