import SwiftUI

struct BreathingModuleView: View {
    let onCompletion: () -> Void
    
    @StateObject private var viewModel = BreathingModuleViewModel()
    @State private var showCompletionPage = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            HStack(alignment: .top, spacing: 0) {
                /// Left side - Phase indicator
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 140.getHeight())
                    
                    BreathingPhaseComponent(viewModel: viewModel)
                    
                    Spacer()
                    
                    /// Round counter
                    Text("Putaran \(viewModel.currentRound)/\(viewModel.totalRounds)")
                        .font(.customFont(size: 24.getWidth(), family: .primary, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40.getWidth())
                        .padding(.vertical, 18.getHeight())
                        .background(
                            Capsule()
                                .fill(ColorToken.corePrimary.toColor())
                        )
                        .padding(.leading, 70.getWidth())
                        .padding(.bottom, 80.getHeight())
                }
                
                Spacer()
                
                /// Right side - Kimo character with background circle
                ZStack {
                    /// Purple background circle
                    Image("BackgroundCircle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1000.getWidth(), height: 1000.getHeight())
                    
                    /// Kimo character
                    Image(viewModel.currentPhase.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 850.getWidth(), height: 850.getHeight())
                }
                .frame(width: 800.getWidth(), height: 800.getHeight())
                .offset(x: 100.getWidth(), y: 200.getHeight())
            }
            
            /// Top overlay - Profile icon and pause button
            VStack {
                HStack {
                    Spacer()
                    
                    /// Profile icon - smaller circle
                    Button(action: {
                        viewModel.showTutorial = true
                    }, label: {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80.getWidth(), height: 80.getHeight())
                            .foregroundStyle(ColorToken.additionalColorsLightPink.toColor())
                    })
                    
                    /// Pause button
                    KimoPauseButton {
                        viewModel.pauseBreathing()
                    }
                    .padding(.trailing, 40.getWidth())
                }
                .padding(.top, 40.getHeight())
                
                Spacer()
            }
            
            /// Tutorial overlay
            if viewModel.showTutorial {
                BreathingModuleTutorialView()
                    .onTapGesture {
                        viewModel.showTutorial = false
                    }
            }
            
            /// Pause overlay
            if viewModel.isPaused {
                BlocksGamePauseView(
                    onReset: {
                        viewModel.resetBreathingCycle()
                        viewModel.startBreathingCycle()
                    },
                    onHome: {
                        dismiss()
                    },
                    onResume: {
                        viewModel.resumeBreathing()
                    }
                )
            }
            
            /// Show completion page overlay when breathing is finished
            if showCompletionPage {
                CompletionPageView(
                    title: "Latihan Selesai!!!",
                    primaryButtonLabel: "Coba lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        /// Reset and restart breathing exercise
                        showCompletionPage = false
                        viewModel.resetBreathingCycle()
                        viewModel.startBreathingCycle()
                    },
                    onSecondaryAction: {
                        /// Continue to next story scene
                        print("DEBUG: Lanjutkan button tapped")
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCompletion()
                        }
                    }
                )
            }
        }
        .onAppear {
            viewModel.startBreathingCycle()
        }
        .onChange(of: viewModel.hasCompleted) {
            if viewModel.hasCompleted {
                showCompletionPage = true
            }
        }
    }
}

// MARK: - Preview
struct BreathingModuleView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingModuleView(onCompletion: {
            print("Breathing exercise completed")
        })
    }
}
