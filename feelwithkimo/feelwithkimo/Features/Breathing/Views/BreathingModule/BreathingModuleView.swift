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
    @ObservedObject var storyViewModel: StoryViewModel
    @Environment(\.dismiss) var dismiss
    var onCompletion: (() -> Void)?
    
    @State var showTutorial: Bool = false
    
    // MARK: - Public Initializer
    public init(onCompletion: (() -> Void)? = nil, storyViewModel: StoryViewModel) {
        self.onCompletion = onCompletion
        _storyViewModel = ObservedObject(wrappedValue: storyViewModel)
    }
    
    var body: some View {
        ZStack {
            // Main breathing view
            mainBreathingView
            
            // Completion overlay
            if viewModel.showCompletionView {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                completionView
            }

            // Back button overlay - top left
            VStack {
                HStack {
                    KimoBackButton {
                        dismiss()
                    }

                    Spacer()
                    
                    Button(action: {
                        showTutorial = true
                    }, label: {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80.getWidth(), height: 80.getHeight())
                            .foregroundStyle(ColorToken.additionalColorsLightPink.toColor())
                    })
                }
                .padding(.horizontal, 55.getWidth())
                .padding(.top, 50.getHeight())

                Spacer()
            }
            .ignoresSafeArea(edges: .all)
            
            if showTutorial {
                TutorialPage(textDialogue:
                "Ikuti instruksi 'Tarik Nafas', 'Tahan Nafas', dan 'Buang Nafas' sambil menirukan Kimo." +
                " Jangan lupa sesuaikan ritmemu dengan timer di kanan. Buang napas perlahan lewat mulut, ya!")
                .onTapGesture {
                    showTutorial = false
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
                    
                    HStack(alignment: .center, spacing: 60.getWidth()) {
                        Text(viewModel.currentPhase.localizedText)
                            .font(.customFont(size: 72, weight: .bold))
                            .foregroundColor(ColorToken.backgroundSecondary.toColor())
                            .multilineTextAlignment(.leading)
                            .lineSpacing(0)
                            .padding(.leading, 60.getWidth())
                            .padding(.top, geometry.safeAreaInsets.top + 100.getHeight())
                            .kimoTextAccessibility(
                                label: "Latihan Pernafasan Tarik Nafas",
                                identifier: "breathing.title",
                                sortPriority: 1
                            )
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.bottom, 100.getWidth())
                
                // Timer circle - top right, fixed position
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(ColorToken.backgroundBreathing.toColor())
                                .frame(width: 143.getWidth(),
                                       height: 143.getWidth())
                            
                            Text("\(viewModel.remainingTime) " + NSLocalizedString("Second", comment: ""))
                                .font(.customFont(size: 30, weight: .bold))
                                .foregroundColor(ColorToken.backgroundSecondary.toColor())
                        }
                        .padding(.trailing, 72.getWidth())
                        .padding(.top, geometry.safeAreaInsets.top + 120.getHeight())
                    }
                    Spacer()
                }
                .padding(.bottom, 100.getWidth())
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
                    
                    VStack(spacing: 20.getHeight()) {
                        if !viewModel.isActive {
                            Button(action: {
                                viewModel.startBreathing()
                                accessibilityManager.announce("Latihan pernapasan dimulai. Ikuti instruksi Kimo")
                            }, label: {
                                Text("Mulai")
                                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                                    .foregroundColor(ColorToken.textPrimary.toColor())
                                    .padding(.horizontal, geometry.size.width * 0.035)
                                    .padding(.vertical, 14.getHeight())
                                    .background(ColorToken.backgroundSecondary.toColor())
                                    .cornerRadius(30)
                            })
                            .kimoButtonAccessibility(
                                label: "Mulai latihan pernapasan",
                                hint: "Ketuk dua kali untuk memulai latihan pernapasan bersama Kimo",
                                identifier: "breathing.startButton"
                            )
                        } else {
                            HStack(spacing: 20.getWidth()) {
                                // Cycle indicator - show when active
                                Text(NSLocalizedString("BreathingPractice", comment: "") + " \(viewModel.cycleCount) / 3")
                                    .font(.customFont(size: 22, family: .primary, weight: .bold))
                                    .foregroundColor(ColorToken.textPrimary.toColor())
                                    .padding(.horizontal, geometry.size.width * 0.035)
                                    .padding(.vertical, 16.getHeight())
                                    .background(ColorToken.backgroundSecondary.toColor())
                                    .cornerRadius(30)
                                
                                // Stop Button
                                Button(action: {
                                    viewModel.isActive = false
                                    viewModel.stopBreathing()
                                }, label: {
                                    Text("Berhenti")
                                        .font(.customFont(size: 28, family: .primary, weight: .bold))
                                        .foregroundColor(ColorToken.backgroundSecondary.toColor())
                                        .padding(.horizontal, geometry.size.width * 0.035)
                                        .padding(.vertical, 14.getHeight())
                                        .background(ColorToken.backgroundBreathing.toColor())
                                        .cornerRadius(30)
                                })
                            }
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
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
        KimoDialogueView(
            textDialogue: NSLocalizedString("BreathingSuccess", comment: ""),
            buttonLayout: .horizontal([
                KimoDialogueButtonConfig(
                    title: NSLocalizedString("Coba Lagi", comment: ""),
                    symbol: .arrowClockwise,
                    style: .bubbleSecondary,
                    action: {
                        viewModel.restartBreathing()
                    }
                ),
                KimoDialogueButtonConfig(
                    title: NSLocalizedString("Lanjutkan", comment: ""),
                    symbol: .chevronRight,
                    style: .bubbleSecondary,
                    action: {
                        dismiss()
                        storyViewModel.goScene(to: 1, choice: 0)
                    }
                )
            ])
        )
    }
}
