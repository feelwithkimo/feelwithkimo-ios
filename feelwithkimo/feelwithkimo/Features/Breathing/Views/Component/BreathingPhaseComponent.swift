import SwiftUI

struct BreathingPhaseComponent: View {
    @ObservedObject var viewModel: BreathingModuleViewModel
    
    let circleSize: CGFloat = 80
    let inactiveCircleSize: CGFloat = 60
    let lineHeight: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<viewModel.phases.count, id: \.self) { index in
                let phase = viewModel.phases[index]
                HStack(spacing: 20) {
                    /// Circle with progress ring
                    ZStack {
                        /// Background circle with stroke
                        Circle()
                            .fill(Color(uiColor: ColorToken.corePinkDialogue))
                            .frame(width: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize,
                                   height: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize)
                            .overlay(
                                Circle()
                                    .stroke(Color(uiColor: ColorToken.backgroundEntry), lineWidth: 12)
                            )
                        
                        /// Progress ring
                        if viewModel.isPhaseActive(index) || viewModel.isPhaseCompleted(index) {
                            Circle()
                                .trim(from: 0, to: viewModel.isPhaseCompleted(index) ? 1.0 : viewModel.circleProgress)
                                .stroke(
                                    Color(uiColor: ColorToken.backgroundSecondary),
                                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                                )
                                .frame(width: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize,
                                       height: viewModel.isPhaseActive(index) ? circleSize : inactiveCircleSize)
                                .rotationEffect(.degrees(-90))
                        }
                        
                        /// Content (number or checkmark)
                        if viewModel.isPhaseCompleted(index) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(uiColor: ColorToken.backgroundSecondary))
                                .font(.system(size: 24, weight: .bold))
                        } else {
                            Text("\(index + 1)")
                                .font(.system(size: viewModel.isPhaseActive(index) ? 32 : 24, weight: .bold))
                                .foregroundColor(Color(uiColor: viewModel.isPhaseActive(index) ?
                                    ColorToken.backgroundSecondary : ColorToken.backgroundEntry))
                        }
                    }
                    .frame(width: circleSize, height: circleSize)
                    .zIndex(1) /// Circle on top
                    
                    /// Phase title
                    Text(phase.title)
                        .font(.system(size: viewModel.isPhaseActive(index) ? 72 : 32,
                                    weight: viewModel.isPhaseActive(index) ? .bold : .semibold))
                        .foregroundColor(Color(uiColor: viewModel.isPhaseActive(index) || viewModel.isPhaseCompleted(index) ?
                                              ColorToken.backgroundSecondary : ColorToken.backgroundEntry))
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                /// Connecting line with progress
                if index < viewModel.phases.count - 1 {
                    HStack(spacing: 20) {
                        ZStack(alignment: .top) {
                            /// Background line
                            Rectangle()
                                .fill(Color(uiColor: ColorToken.backgroundEntry))
                                .frame(width: 12, height: lineHeight)
                            
                            /// Progress line
                            if viewModel.isPhaseCompleted(index) {
                                Rectangle()
                                    .fill(Color(uiColor: ColorToken.backgroundSecondary))
                                    .frame(width: 12, height: lineHeight)
                            } else if viewModel.isPhaseActive(index) {
                                Rectangle()
                                    .fill(Color(uiColor: ColorToken.backgroundSecondary))
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
        .padding(.leading, 50)
    }
}
