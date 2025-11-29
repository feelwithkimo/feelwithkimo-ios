import SwiftUI

struct BreathingPhaseComponent: View {
    @ObservedObject var viewModel: BreathingModuleViewModel
    
    let circleSize: CGFloat = 80.getWidth()
    let inactiveCircleSize: CGFloat = 60.getWidth()
    let lineHeight: CGFloat = 100.getHeight()
    let strokeWidth: CGFloat = 12 // Circle stroke width
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            /// Background layer - All connecting lines
            VStack(alignment: .leading, spacing: 0) {
                ForEach(BreathingPhase.allCases, id: \.self) { phase in
                    /// Spacer for circle area
                    Color.clear
                        .frame(width: circleSize, height: circleSize)
                    
                    /// Connecting line with progress
                    if phase.id < viewModel.totalPhaseCount - 1 {
                        let isCurrentPhaseActive = viewModel.isPhaseActive(phase.id)
                        let isCurrentPhaseCompleted = viewModel.isPhaseCompleted(phase.id)
                        let isNextPhaseActive = viewModel.isPhaseActive(phase.id + 1)
                        let isNextPhaseCompleted = viewModel.isPhaseCompleted(phase.id + 1)
                        
                        /// Calculate extensions needed to reach the outer edge of the circle strokes
                        /// Circles have a 12pt stroke, so we need to account for stroke/2 = 6pt on each side
                        
                        let currentCircleSize = (isCurrentPhaseActive || isCurrentPhaseCompleted) ? circleSize : inactiveCircleSize
                        let nextCircleSize = (isNextPhaseActive || isNextPhaseCompleted) ? circleSize : inactiveCircleSize
                        
                        /// Distance from bottom of frame to bottom outer edge of stroke
                        let topGap = (circleSize - currentCircleSize) / 2 + strokeWidth / 2
                        /// Distance from top of frame to top outer edge of stroke
                        let bottomGap = (circleSize - nextCircleSize) / 2 + strokeWidth / 2
                        
                        /// Extend line to reach the stroke edges
                        let extendedHeight = lineHeight + topGap + bottomGap
                        
                        HStack(spacing: 20.getWidth()) {
                            ZStack(alignment: .top) {
                                /// Background line
                                Rectangle()
                                    .fill(ColorToken.backgroundEntry.toColor())
                                    .frame(width: 12, height: extendedHeight)
                                    .offset(y: -topGap)
                                
                                /// Progress line
                                if viewModel.isPhaseCompleted(phase.id) {
                                    Rectangle()
                                        .fill(ColorToken.backgroundSecondary.toColor())
                                        .frame(width: 12, height: extendedHeight)
                                        .offset(y: -topGap)
                                } else if viewModel.isPhaseActive(phase.id) {
                                    Rectangle()
                                        .fill(ColorToken.backgroundSecondary.toColor())
                                        .frame(width: 12, height: extendedHeight * viewModel.lineProgress)
                                        .offset(y: -topGap)
                                }
                            }
                            .frame(width: circleSize, alignment: .center)
                            
                            Spacer()
                        }
                    }
                }
            }
            .zIndex(0) /// Lines at the back
            
            /// Foreground layer - Circles and text
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
                        
                        /// Phase title
                        Text(phase.localizedText)
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
                    
                    /// Spacer for connecting line
                    if phase.id < viewModel.totalPhaseCount - 1 {
                        Color.clear
                            .frame(height: lineHeight)
                    }
                }
            }
            .zIndex(1) /// Circles on top
        }
        .padding(.leading, 50.getWidth())
    }
}
