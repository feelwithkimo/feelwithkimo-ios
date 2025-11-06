//
//  KimoDialogueButton.swift
//  feelwithkimo
//
//  Created by GitHub Copilot on 03/11/25.
//

import SwiftUI

// MARK: - SF Symbol Name Helper
enum SFSymbolName: String {
    case play = "play.fill"
    case arrowClockwise = "arrow.trianglehead.2.clockwise.rotate.90"
    case chevronRight = "chevron.right"
}

// MARK: - Button Style Types
enum KimoDialogueButtonStyle {
    case regular         // Standard button style
    case bubblePrimary   // Bubble button with primary styling
    case bubbleSecondary // Bubble button with secondary styling
    case bubbleTertiary  // Bubble button with tertiary styling
    case bubbleStretched // Bubble button stretched styling
}

// MARK: - Button Configuration
struct KimoDialogueButtonConfig {
    let title: String
    let symbol: SFSymbolName?
    let style: KimoDialogueButtonStyle
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    init(
        title: String,
        symbol: SFSymbolName? = nil,
        style: KimoDialogueButtonStyle = .regular,
        backgroundColor: Color = ColorToken.backgroundCard.toColor(),
        foregroundColor: Color = ColorToken.additionalColorsWhite.toColor(),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.symbol = symbol
        self.style = style
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }
}

// MARK: - Button Layout Types
enum KimoDialogueButtonLayout {
    case none                                    // No buttons
    case single(KimoDialogueButtonConfig)        // One button
    case horizontal([KimoDialogueButtonConfig])  // Two buttons side by side
    case vertical([KimoDialogueButtonConfig])    // Two buttons stacked vertically
}

// MARK: - Custom Button View
struct KimoDialogueButton: View {
    let config: KimoDialogueButtonConfig
    let isFullWidth: Bool
    
    init(config: KimoDialogueButtonConfig, isFullWidth: Bool = false) {
        self.config = config
        self.isFullWidth = isFullWidth
    }
    
    var body: some View {
        Button(action: config.action) {
            switch config.style {
            case .regular:
                regularButtonContent
            case .bubblePrimary:
                bubbleButtonContent(imageName: "KimoBubbleButton", width: 253.getWidth())
            case .bubbleSecondary:
                bubbleButtonContent(imageName: "KimoBubbleButtonSecondary", width: 253.getWidth())
            case .bubbleTertiary:
                bubbleButtonContent(imageName: "KimoBubbleButtonTertiary", width: 253.getWidth())
            case .bubbleStretched:
                bubbleButtonContent(imageName: "KimoBubbleButtonStretched", width: 442.getWidth())
            }
        }
        .buttonStyle(.plain)
    }
    
    private var regularButtonContent: some View {
        HStack(spacing: 12) {
            if let symbol = config.symbol {
                Image(systemName: symbol.rawValue)
                    .font(.app(.title1, family: .primary))
            }
            Text(config.title)
                .font(.app(.title1, family: .primary))
        }
        .foregroundStyle(Color(config.foregroundColor))
        .padding(.horizontal, 20)
        .padding(.vertical, 15.5)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .background(Color(config.backgroundColor))
        .cornerRadius(30)
    }
    
    private func bubbleButtonContent(imageName: String, width: CGFloat) -> some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .padding(0)
            
            HStack(spacing: 20) {
                if let symbol = config.symbol {
                    Image(systemName: symbol.rawValue)
                        .font(.app(.title1, family: .primary))
                }
                Text(config.title)
                    .font(.app(.title1, family: .primary))
            }
            .foregroundStyle(ColorToken.textPrimary.toColor())
            .padding(.bottom, 8.getHeight())
        }
        .frame(maxWidth: width)
        .cornerRadius(100)
    }
}

// MARK: - Buttons Container View
struct KimoDialogueButtonsView: View {
    let layout: KimoDialogueButtonLayout
    
    var body: some View {
        switch layout {
        case .none:
            EmptyView()
            
        case .single(let config):
            HStack {
                Spacer()
                KimoDialogueButton(config: config)
            }
            
        case .horizontal(let configs):
            HStack(spacing: 12) {
                Spacer()
                ForEach(configs.indices, id: \.self) { index in
                    KimoDialogueButton(config: configs[index])
                }
            }
            
        case .vertical(let configs):
            VStack(spacing: 12) {
                ForEach(configs.indices, id: \.self) { index in
                    HStack {
                        Spacer()
                        KimoDialogueButton(config: configs[index], isFullWidth: false)
                    }
                }
            }
        }
    }
}

// MARK: - Preview Helper
#if DEBUG
struct KimoDialogueButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Single button
            KimoDialogueButtonsView(
                layout: .single(
                    KimoDialogueButtonConfig(
                        title: "Mulai bermain",
                        symbol: .play,
                        action: { print("Single button tapped") }
                    )
                )
            )
            
            // Bubble Primary Button (no symbol)
            KimoDialogueButtonsView(
                layout: .single(
                    KimoDialogueButtonConfig(
                        title: "Ayo Mulai!",
                        symbol: .play,
                        style: .bubblePrimary,
                        action: { print("Bubble primary tapped") }
                    )
                )
            )
            
            // Bubble Secondary Button with SF Symbol
            KimoDialogueButtonsView(
                layout: .single(
                    KimoDialogueButtonConfig(
                        title: "Mulai Lagi",
                        symbol: .arrowClockwise,
                        style: .bubbleSecondary,
                        action: { print("Bubble secondary tapped") }
                    )
                )
            )
            
            // Two horizontal bubble buttons with SF Symbols (like in image)
            KimoDialogueButtonsView(
                layout: .horizontal([
                    KimoDialogueButtonConfig(
                        title: "Coba lagi",
                        symbol: .arrowClockwise,
                        style: .bubblePrimary,
                        action: { print("Try again tapped") }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Lanjutkan",
                        symbol: .chevronRight,
                        style: .bubbleSecondary,
                        action: { print("Continue tapped") }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Ayo Mulai",
                        style: .bubbleTertiary,
                        action: { print("Continue tapped") }
                    )
                ])
            )
            
            // Two horizontal regular buttons
            KimoDialogueButtonsView(
                layout: .horizontal([
                    KimoDialogueButtonConfig(
                        title: "Coba lagi",
                        symbol: .arrowClockwise,
                        backgroundColor: ColorToken.coreSecondary.toColor(),
                        foregroundColor: ColorToken.textPrimary.toColor(),
                        action: { print("Try again tapped") }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Lanjutkan",
                        symbol: .chevronRight,
                        action: { print("Continue tapped") }
                    )
                ])
            )
            
            // Two vertical buttons (without symbols)
            KimoDialogueButtonsView(
                layout: .vertical([
                    KimoDialogueButtonConfig(
                        title: "Menendang balok-baloknya",
                        action: { print("Option A tapped") }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Menendang balok-baloknya",
                        style: .bubbleStretched,
                        action: { print("Continue tapped") }
                    ),
                    KimoDialogueButtonConfig(
                        title: "Duduk sejenak untuk berpikir",
                        action: { print("Option B tapped") }
                    )
                ])
            )
        }
        .padding()
        .background(ColorToken.coreSecondary.toColor())
    }
}
#endif
