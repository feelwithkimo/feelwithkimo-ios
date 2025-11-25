import SwiftUI

struct BreathingPhaseComponent: View {
    @ObservedObject var viewModel: BreathingModuleViewModel
    
    let circleSize: CGFloat = 80.getWidth()
    let inactiveCircleSize: CGFloat = 60.getWidth()
    let lineHeight: CGFloat = 100.getHeight()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(BreathingPhase.allCases, id: \.self) { phase in
                HStack(spacing: 20.getWidth()) {
                    /// Circle with progress ring
                    ZStack {
                        /// Background circle with stroke
                        Circle()
                            .fill(ColorToken.corePinkDialogue.toColor())
                            .frame(width: viewModel.isPhaseActive(phase.id) ? circleSize : inactiveCircleSize,
                                   height: viewModel.isPhaseActive(phase.id) ? circleSize : inactiveCircleSize)
                            .overlay(
                                Circle()
                                    .stroke(ColorToken.backgroundEntry.toColor(), lineWidth: 12)
                            )
                        
                        /// Progress ring
                        if viewModel.isPhaseActive(phase.id) || viewModel.isPhaseCompleted(phase.id) {
                            Circle()
                                .trim(from: 0, to: viewModel.isPhaseCompleted(phase.id) ? 1.0 : viewModel.circleProgress)
                                .stroke(
                                    ColorToken.backgroundSecondary.toColor(),
                                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                                )
                                .frame(width: viewModel.isPhaseActive(phase.id) ? circleSize : inactiveCircleSize,
                                       height: viewModel.isPhaseActive(phase.id) ? circleSize : inactiveCircleSize)
                                .rotationEffect(.degrees(-90))
                        }
                        
                        /// Content (number or checkmark)
                        if viewModel.isPhaseCompleted(phase.id) {
                            Image(systemName: "checkmark")
                                .foregroundColor(ColorToken.backgroundSecondary.toColor())
                                .font(.system(size: 24, weight: .bold))
                        } else {
                            Text("\(phase.id + 1)")
                                .font(.customFont(
                                    size: viewModel.isPhaseActive(phase.id) ? 32.getWidth() : 24.getWidth(),
                                    family: .primary,
                                    weight: .bold
                                ))
                                .foregroundColor(viewModel.isPhaseActive(phase.id) ?
                                    ColorToken.backgroundSecondary.toColor() : ColorToken.backgroundEntry.toColor())
                        }
                    }
                    .frame(width: circleSize, height: circleSize)
                    .zIndex(1) /// Circle on top
                    
                    /// Phase title
                    Text(phase.rawValue)
                        .font(.customFont(
                            size: viewModel.isPhaseActive(phase.id) ? 56.getWidth() : 32.getWidth(),
                            family: .primary,
                            weight: viewModel.isPhaseActive(phase.id) ? .bold : .semibold
                        ))
                        .foregroundColor(viewModel.isPhaseActive(phase.id) || viewModel.isPhaseCompleted(phase.id) ?
                                          ColorToken.backgroundSecondary.toColor() : ColorToken.backgroundEntry.toColor())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                /// Connecting line with progress
                if phase.id < viewModel.totalPhaseCount - 1 {
                    HStack(spacing: 20.getWidth()) {
                        ZStack(alignment: .top) {
                            /// Background line
                            Rectangle()
                                .fill(ColorToken.backgroundEntry.toColor())
                                .frame(width: 12, height: lineHeight)
                            
                            /// Progress line
                            if viewModel.isPhaseCompleted(phase.id) {
                                Rectangle()
                                    .fill(ColorToken.backgroundSecondary.toColor())
                                    .frame(width: 12, height: lineHeight)
                            } else if viewModel.isPhaseActive(phase.id) {
                                Rectangle()
                                    .fill(ColorToken.backgroundSecondary.toColor())
                                    .frame(width: 12, height: lineHeight * viewModel.lineProgress)
                            }
                        }
                        .frame(width: circleSize, alignment: .center)
                        .zIndex(0) /// Line behind
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.leading, 50.getWidth())
    }
}
