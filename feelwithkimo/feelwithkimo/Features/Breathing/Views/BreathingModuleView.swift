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
                        .frame(height: 140)
                    
                    BreathingPhaseComponent(viewModel: viewModel)
                    
                    Spacer()
                    
                    /// Round counter
                    Text("Putaran \(viewModel.currentRound)/\(viewModel.totalRounds)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(Color(red: 108/255, green: 99/255, blue: 140/255))
                        )
                        .padding(.leading, 70)
                        .padding(.bottom, 80)
                }
                
                Spacer()
                
                /// Right side - Kimo character with background circle
                ZStack {
                    /// Purple background circle
                    Image("BackgroundCircle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1000, height: 1000)
                    
                    /// Kimo character
                    Image(viewModel.getCurrentPhaseImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 850, height: 850)
                }
                .frame(width: 800, height: 800)
                .offset(x: 100, y: 200)
            }
            
            /// Top overlay - Profile icon and pause button
            VStack {
                HStack {
                    Spacer()
                    
                    /// Profile icon - smaller circle
                    Circle()
                        .fill(Color(red: 186/255, green: 178/255, blue: 214/255))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 108/255, green: 99/255, blue: 140/255), lineWidth: 3)
                        )
                        .padding(.trailing, 8)
                    
                    /// Pause button
                    KimoPauseButton {
                        viewModel.pauseBreathing()
                    }
                    .padding(.trailing, 40)
                }
                .padding(.top, 40)
                
                Spacer()
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
        .onChange(of: viewModel.hasCompleted) { completed in
            if completed {
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
