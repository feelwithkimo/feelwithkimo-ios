import SwiftUI

struct BreathingModuleView: View {
    let onCompletion: () -> Void
    
    @StateObject private var viewModel = BreathingModuleViewModel()
    @State private var showCompletionPage = false
    @State private var circleScale: CGFloat = 0.5
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            mainContentView
            topOverlayView
            tutorialOverlay
            pauseOverlay
            completionOverlay
        }
        .onAppear {
            // Initialize to small size
            circleScale = 0.5
            viewModel.startBreathingCycle()
            // Delay sync to ensure view is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                syncAnimations()
            }
        }
        .onChange(of: viewModel.hasCompleted) {
            if viewModel.hasCompleted {
                showCompletionPage = true
            }
        }
        .onChange(of: viewModel.currentPhase) {
            syncAnimations()
        }
        .onChange(of: viewModel.phaseCounter) {
            // Update currentPhase based on phaseCounter
            updatePhaseFromCounter()
            syncAnimations()
        }
        .onChange(of: viewModel.isAnimating) {
            if !viewModel.isAnimating {
                circleScale = 0.5
            }
        }
    }
    
    // MARK: - Main Content
    private var mainContentView: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            HStack(alignment: .top, spacing: 0) {
                leftSideContent
                Spacer()
                rightSideContent
            }
        }
    }
    
    // MARK: - Left Side
    private var leftSideContent: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 140.getHeight())
            
            BreathingPhaseComponent(viewModel: viewModel)
            
            Spacer()
            
            roundCounter
        }
    }
    
    private var roundCounter: some View {
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
    
    // MARK: - Right Side
    private var rightSideContent: some View {
        ZStack {
            animatedBreathingCircles
            kimoCharacter
        }
        .frame(width: 800.getWidth(), height: 800.getHeight())
        .offset(x: 100.getWidth(), y: 200.getHeight())
    }
    
    private var animatedBreathingCircles: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                breathingCircle(at: index)
            }
        }
    }
    
    private func breathingCircle(at index: Int) -> some View {
        let baseSize: CGFloat = 400
        let sizeIncrement: CGFloat = 80
        let maxSize = (baseSize + CGFloat(index) * sizeIncrement) * circleScale
        
        return Circle()
            .fill(
                RadialGradient(
                    colors: [
                        ColorToken.corePrimary.toColor().opacity(1.0),
                        ColorToken.corePrimary.toColor().opacity(0.4),
                        ColorToken.corePrimary.toColor().opacity(0.3),
                        ColorToken.corePrimary.toColor().opacity(0.2)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: maxSize * 0.5
                )
            )
            .frame(width: maxSize, height: maxSize)
            .animation(
                .easeInOut(duration: viewModel.currentPhase.duration)
                    .delay(Double(index) * 0.2),
                value: circleScale
            )
    }
    
    private var kimoCharacter: some View {
        Image(viewModel.currentPhase.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 850.getWidth(), height: 850.getHeight())
    }
    
    // MARK: - Top Overlay
    private var topOverlayView: some View {
        VStack {
            HStack {
                Spacer()
                tutorialButton
                pauseButton
            }
            .padding(.top, 40.getHeight())
            
            Spacer()
        }
    }
    
    private var tutorialButton: some View {
        Button(action: {
            viewModel.showTutorial = true
        }) {
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80.getWidth(), height: 80.getHeight())
                .foregroundStyle(ColorToken.additionalColorsLightPink.toColor())
        }
    }
    
    private var pauseButton: some View {
        KimoPauseButton {
            viewModel.pauseBreathing()
        }
        .padding(.trailing, 40.getWidth())
    }
    
    // MARK: - Overlays
    @ViewBuilder
    private var tutorialOverlay: some View {
        if viewModel.showTutorial {
            BreathingModuleTutorialView()
                .onTapGesture {
                    viewModel.showTutorial = false
                }
        }
    }
    
    @ViewBuilder
    private var pauseOverlay: some View {
        if viewModel.isPaused {
            PauseView(
                onReset: {
                    viewModel.resetBreathingCycle()
                    viewModel.startBreathingCycle()
                    syncAnimations()
                },
                onHome: {
                    dismiss()
                },
                onResume: {
                    viewModel.resumeBreathing()
                    syncAnimations()
                },
                onBack: {
                    dismiss()
                }
            )
        }
    }
    
    @ViewBuilder
    private var completionOverlay: some View {
        if showCompletionPage {
            CompletionPageView(
                title: "Latihan Selesai!!!",
                primaryButtonLabel: "Coba lagi",
                secondaryButtonLabel: "Lanjutkan",
                onPrimaryAction: {
                    showCompletionPage = false
                    viewModel.resetBreathingCycle()
                    viewModel.startBreathingCycle()
                    syncAnimations()
                },
                onSecondaryAction: {
                    print("DEBUG: Lanjutkan button tapped")
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onCompletion()
                    }
                }
            )
        }
    }
    
    // MARK: - Animation Sync
    private func updatePhaseFromCounter() {
        let phases: [BreathingPhase] = [.inhale, .hold, .exhale]
        let index = viewModel.phaseCounter % phases.count
        viewModel.currentPhase = phases[index]
    }
    
    private func syncAnimations() {
        switch viewModel.currentPhase {
        case .inhale:
            // Expand circles
            circleScale = 1.5
        case .hold:
            // Stay expanded
            circleScale = 1.5
        case .exhale:
            // Contract circles
            circleScale = 0.5
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
