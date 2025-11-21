import SwiftUI

struct BreathingPhaseComponent: View {
    @State private var currentPhase: Int = 0
    @State private var progress: CGFloat = 0
    @State private var isAnimating = false
    
    let phases: [(id: Int, title: String, duration: Double)] = [
        (id: 0, title: "Tarik Nafas", duration: 4.0),
        (id: 1, title: "Tahan Nafas", duration: 3.0),
        (id: 2, title: "Hembus Nafas", duration: 4.0)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<phases.count, id: \.self) { index in
                let phase = phases[index]
                HStack(spacing: 16) {
                    // Circle with progress ring
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(Color(uiColor: isPhaseCompleted(index) || isPhaseActive(index) ?
                                       ColorToken.corePrimary : ColorToken.corePrimary.withAlphaComponent(0.3)))
                            .frame(width: 48, height: 48)
                        
                        // Progress ring
                        if isPhaseActive(index) {
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    Color(uiColor: ColorToken.coreAccent),
                                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                )
                                .frame(width: 48, height: 48)
                                .rotationEffect(.degrees(-90))
                        }
                        
                        // Content (number or checkmark)
                        if isPhaseCompleted(index) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(uiColor: ColorToken.additionalColorsWhite))
                                .font(.system(size: 20, weight: .bold))
                        } else {
                            Text("\(index + 1)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(uiColor: isPhaseActive(index) ?
                                                      ColorToken.additionalColorsWhite :
                                                      ColorToken.textSecondary))
                        }
                    }
                    
                    // Phase title
                    Text(phase.title)
                        .font(.system(size: isPhaseActive(index) ? 24 : 20,
                                    weight: isPhaseActive(index) ? .bold : .regular))
                        .foregroundColor(Color(uiColor: isPhaseActive(index) ?
                                              ColorToken.textPrimary : ColorToken.textSecondary))
                    
                    Spacer()
                }
                
                // Connecting line with progress
                if index < phases.count - 1 {
                    HStack(spacing: 16) {
                        ZStack(alignment: .top) {
                            // Background line
                            Rectangle()
                                .fill(Color(uiColor: ColorToken.corePrimary.withAlphaComponent(0.3)))
                                .frame(width: 4, height: 80)
                            
                            // Progress line
                            if isPhaseCompleted(index) {
                                Rectangle()
                                    .fill(Color(uiColor: ColorToken.coreAccent))
                                    .frame(width: 4, height: 80)
                            } else if isPhaseActive(index) {
                                Rectangle()
                                    .fill(Color(uiColor: ColorToken.coreAccent))
                                    .frame(width: 4, height: 80 * progress)
                            }
                        }
                        .frame(width: 48, alignment: .center)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.leading, 32)
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
        progress = 0
        
        let currentPhaseDuration = phases[currentPhase].duration
        
        withAnimation(.linear(duration: currentPhaseDuration)) {
            progress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + currentPhaseDuration) {
            currentPhase += 1
            
            if currentPhase < phases.count {
                startBreathingCycle()
            } else {
                isAnimating = false
            }
        }
    }
}

// MARK: - Preview
struct BreathingPhaseComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(uiColor: ColorToken.backgroundBreathing)
                .ignoresSafeArea()
            
            BreathingPhaseComponent()
        }
    }
}
