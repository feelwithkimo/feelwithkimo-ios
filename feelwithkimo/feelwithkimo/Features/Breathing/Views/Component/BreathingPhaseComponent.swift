import SwiftUI

struct BreathingPhaseComponent: View {
    @ObservedObject var viewModel: BreathingModuleViewModel
    
    let circleSize: CGFloat = 80.getWidth()
    let inactiveCircleSize: CGFloat = 60.getWidth()
    let lineHeight: CGFloat = 100.getHeight()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<viewModel.phases.count, id: \.self) { index in
                let phase = viewModel.phases[index]
                HStack(spacing: 20.getWidth()) {
                    /// Circle with progress ring
                    ZStack {
                        /// Background circle with stroke
                        Circle()
                            .fill(ColorToken.corePinkDialogue.toColor())
                            .frame(width: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize,
                                   height: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize)
                            .overlay(
                                Circle()
                                    .stroke(ColorToken.backgroundEntry.toColor(), lineWidth: 12)
                            )
                        
                        /// Progress ring
                        if viewModel.isPhaseActive(index) || viewModel.isPhaseCompleted(index) {
                            Circle()
                                .trim(from: 0, to: viewModel.isPhaseCompleted(index) ? 1.0 : viewModel.circleProgress)
                                .stroke(
                                    ColorToken.backgroundSecondary.toColor(),
                                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                                )
                                .frame(width: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize,
                                       height: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize)
                                .rotationEffect(.degrees(-90))
                        }
                        
                        /// Content (number or checkmark)
                        if viewModel.isPhaseCompleted(index) {
                            Image(systemName: "checkmark")
                                .foregroundColor(ColorToken.backgroundSecondary.toColor())
                                .font(.system(size: 24, weight: .bold))
                        } else {
                            Text("\(index + 1)")
                                .font(.customFont(
                                    size: viewModel.isPhaseActive(index) ? 32.getWidth() : 24.getWidth(),
                                    family: .primary,
                                    weight: .bold
                                ))
                                .foregroundColor(viewModel.isPhaseActive(index) ?
                                    ColorToken.backgroundSecondary.toColor() : ColorToken.backgroundEntry.toColor())
                        }
                    }
                    .frame(width: circleSize, height: circleSize)
                    .zIndex(1) /// Circle on top
                    
                    /// Phase title
                    Text(phase.title)
                        .font(.customFont(
                            size: viewModel.isPhaseActive(index) ? 56.getWidth() : 32.getWidth(),
                            family: .primary,
                            weight: viewModel.isPhaseActive(index) ? .bold : .semibold
                        ))
                        .foregroundColor(viewModel.isPhaseActive(index) || viewModel.isPhaseCompleted(index) ?
                                          ColorToken.backgroundSecondary.toColor() : ColorToken.backgroundEntry.toColor())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                /// Connecting line with progress
                if index < viewModel.phases.count - 1 {
                    HStack(spacing: 20.getWidth()) {
                        ZStack(alignment: .top) {
                            /// Background line
                            Rectangle()
                                .fill(ColorToken.backgroundEntry.toColor())
                                .frame(width: 12, height: lineHeight)
                            
                            /// Progress line
                            if viewModel.isPhaseCompleted(index) {
                                Rectangle()
                                    .fill(ColorToken.backgroundSecondary.toColor())
                                    .frame(width: 12, height: lineHeight)
                            } else if viewModel.isPhaseActive(index) {
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
