import SwiftUI

struct BreathingModuleView: View {
    let onCompletion: () -> Void
    
    @State private var currentPhase: Int = 0
    @State private var circleProgress: CGFloat = 0
    @State private var lineProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var hasCompleted = false
    
    let phases: [(id: Int, title: String, duration: Double)] = [
        (id: 0, title: "Tarik Nafas", duration: 4.0),
        (id: 1, title: "Tahan Nafas", duration: 3.0),
        (id: 2, title: "Hembus Nafas", duration: 4.0)
    ]
    
    // Constants for path calculations
    let circleSize: CGFloat = 60
    let lineHeight: CGFloat = 80
    
    var circleCircumference: CGFloat {
        .pi * circleSize
    }
    
    var totalPathLength: CGFloat {
        circleCircumference + lineHeight
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: ColorToken.backgroundBreathing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Breathing Phase Component
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<phases.count, id: \.self) { index in
                        let phase = phases[index]
                        HStack(spacing: 16) {
                            // Circle with progress ring
                            ZStack {
                                // Background circle with stroke
                                Circle()
                                    .fill(Color(uiColor: ColorToken.corePinkDialogue))
                                    .frame(width: isPhaseActive(index) ? circleSize : 48,
                                           height: isPhaseActive(index) ? circleSize : 48)
                                    .overlay(
                                        Circle()
                                            .stroke(Color(uiColor: ColorToken.backgroundEntry), lineWidth: 2)
                                    )
                                
                                // Progress ring
                                if isPhaseActive(index) {
                                    Circle()
                                        .trim(from: 0, to: circleProgress)
                                        .stroke(
                                            Color(uiColor: ColorToken.backgroundSecondary),
                                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                        )
                                        .frame(width: circleSize, height: circleSize)
                                        .rotationEffect(.degrees(-90))
                                }
                                
                                // Content (number or checkmark)
                                if isPhaseCompleted(index) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color(uiColor: ColorToken.backgroundSecondary))
                                        .font(.system(size: 20, weight: .bold))
                                } else {
                                    Text("\(index + 1)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(uiColor: ColorToken.backgroundSecondary))
                                }
                            }
                            .frame(width: circleSize, height: circleSize)
                            
                            // Phase title
                            Text(phase.title)
                                .font(.system(size: isPhaseActive(index) ? 28 : 20,
                                            weight: isPhaseActive(index) ? .bold : .regular))
                                .foregroundColor(Color(uiColor: isPhaseActive(index) ?
                                                      ColorToken.backgroundSecondary : ColorToken.backgroundEntry))
                            
                            Spacer()
                        }
                        
                        // Connecting line with progress
                        if index < phases.count - 1 {
                            HStack(spacing: 16) {
                                ZStack(alignment: .top) {
                                    // Background line
                                    Rectangle()
                                        .fill(Color(uiColor: ColorToken.backgroundEntry))
                                        .frame(width: 4, height: 80)
                                    
                                    // Progress line
                                    if isPhaseCompleted(index) {
                                        Rectangle()
                                            .fill(Color(uiColor: ColorToken.backgroundSecondary))
                                            .frame(width: 4, height: 80)
                                    } else if isPhaseActive(index) {
                                        Rectangle()
                                            .fill(Color(uiColor: ColorToken.backgroundSecondary))
                                            .frame(width: 4, height: 80 * lineProgress)
                                    }
                                }
                                .frame(width: 48, alignment: .center)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.leading, 32)
                
                Spacer()
                
                // Continue button (shown after completion)
                if hasCompleted {
                    Button(action: {
                        onCompletion()
                    }) {
                        Text("Lanjutkan")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(uiColor: ColorToken.additionalColorsWhite))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(uiColor: ColorToken.corePrimary))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            startBreathingCycle()
        }
    }
    
    private func isPhaseActive(_ index: Int) -> Bool {
        return currentPhase == index && isAnimating
    }
    
    private func isPhaseCompleted(_ index: Int) -> Bool {
        return index < currentPhase
    }
    
    private func startBreathingCycle() {
        guard currentPhase < phases.count else { return }
        
        isAnimating = true
        circleProgress = 0
        lineProgress = 0
        
        let currentPhaseDuration = phases[currentPhase].duration
        
        // Calculate durations based on path lengths for constant velocity
        let circleDuration = (circleCircumference / totalPathLength) * currentPhaseDuration
        let lineDuration = (lineHeight / totalPathLength) * currentPhaseDuration
        
        // Animate circle first
        withAnimation(.linear(duration: circleDuration)) {
            circleProgress = 1.0
        }
        
        // After circle completes, animate line (only if not last phase)
        if currentPhase < phases.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + circleDuration) {
                withAnimation(.linear(duration: lineDuration)) {
                    lineProgress = 1.0
                }
            }
        }
        
        // Move to next phase after total duration
        DispatchQueue.main.asyncAfter(deadline: .now() + currentPhaseDuration) {
            currentPhase += 1
            
            if currentPhase < phases.count {
                startBreathingCycle()
            } else {
                isAnimating = false
                hasCompleted = true
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

