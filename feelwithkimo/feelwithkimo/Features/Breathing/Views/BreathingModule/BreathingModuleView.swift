//
//  BreathingViewMidfi.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 30/10/25.
//
import SwiftUI

struct BreathingModuleView: View {
    @StateObject private var viewModel = BreathingModuleViewModel()
    
    var onCompletion: (() -> Void)?
    
    // MARK: - Public Initializer
    public init(onCompletion: (() -> Void)? = nil) {
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        ZStack {
            // Main breathing view
            mainBreathingView
            
            // Completion overlay
            if viewModel.showCompletionView {
                completionView
            }
        }
        .onAppear {
            viewModel.onCompletion = onCompletion
        }
        .onDisappear {
            viewModel.stopBreathing()
        }
    }
    
    // MARK: - Main Breathing View
    private var mainBreathingView: some View {
        VStack(spacing: 40) {
            // Title
            Text("Pernafasan")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(ColorToken.textSecondary.toColor())
            
            // Breathing animation circle
            ZStack {
                // Background breathing circles
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(.mint.opacity(0.2 - Double(index) * 0.05), lineWidth: 5)
                            .frame(width: viewModel.startAnimation ? 400 + CGFloat(index * 50) : 200 + CGFloat(index * 30), 
                                   height: viewModel.startAnimation ? 400 + CGFloat(index * 50) : 200 + CGFloat(index * 30))
                            .animation(.easeInOut(duration: 3).delay(Double(index) * 0.2), value: viewModel.startAnimation)
                    }
                }
                .opacity(0.4)
                
                // Kimo breathing image
                Image(viewModel.currentPhase.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .scaleEffect(viewModel.animationScale)
                    .animation(.easeInOut(duration: viewModel.currentPhase.duration), value: viewModel.animationScale)
            }
            
            Spacer()
            
            // Breathing instructions and countdown
            VStack(spacing: 10) {
                Text(viewModel.currentPhase.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorToken.textSecondary.toColor())
                
                Text("\(viewModel.remainingTime)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(ColorToken.textSecondary.toColor())
            }
            
            // Start/Stop button
            Button(action: {
                if viewModel.isActive {
                    viewModel.stopBreathing()
                } else {
                    viewModel.startBreathing()
                }
            }, label: {
                Text(viewModel.isActive ? "Berhenti" : "Mulai")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(ColorToken.textPrimary.toColor())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ColorToken.backgroundMain.toColor())
                    .cornerRadius(12)
            })
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .background(ColorToken.additionalColorsWhite.toColor())
        .overlay(
            // Tappable Kimo mascot overlay - completely isolated from breathing animations
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleMascot()
                    }, label: {
                        Image("Kimo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .scaleEffect(viewModel.kimoMascotScale)
                    })
                    .padding(.trailing, 30)
                    .padding(.bottom, 150)
                }
            }
            .animation(.none, value: UUID()) // Completely disable any external animations
        )
    }
    
    // MARK: - Completion View
    private var completionView: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Completion dialog
            VStack(spacing: 30) {
                // Kimo image in circle
                ZStack {
                    Circle()
                        .fill(ColorToken.additionalColorsWhite.toColor())
                        .frame(width: 200, height: 200)
                    
                    Image("Kimo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                }
                
                // Question text
                Text("Apa yang kamu rasakan ketika tarik nafas?")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(ColorToken.textPrimary.toColor())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Action buttons
                HStack(spacing: 20) {
                    // Play again button
                    Button(action: {
                        viewModel.restartBreathing()
                    }, label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Mulai Lagi")
                        }
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(ColorToken.textPrimary.toColor())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ColorToken.backgroundMain.toColor())
                        .cornerRadius(12)
                    })
                    
                    // Continue button
                    Button(action: {
                        viewModel.finishSession()
                    }, label: {
                        HStack {
                            Text("Lanjutkan")
                            Image(systemName: "chevron.right")
                        }
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(ColorToken.additionalColorsWhite.toColor())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ColorToken.corePrimary.toColor())
                        .cornerRadius(12)
                    })
                }
                .padding(.horizontal, 20)
            }
            .padding(30)
            .background(ColorToken.additionalColorsWhite.toColor())
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    BreathingModuleView(onCompletion: {
        print("Breathing exercise completed")
    })
}
