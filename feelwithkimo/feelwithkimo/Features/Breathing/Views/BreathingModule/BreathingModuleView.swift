//
//  BreathingViewMidfi.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 30/10/25.
//
import SwiftUI

struct BreathingModuleView: View {
    @StateObject private var viewModel = BreathingModuleViewModel()
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
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
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman latihan pernafasan. Ikuti instruksi Kimo untuk bernapas dengan tenang.")
            }
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
                .kimoTextAccessibility(
                    label: "Latihan Pernafasan",
                    identifier: "breathing.title",
                    sortPriority: 1
                )
            
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
                    .kimoImageAccessibility(
                        label: "Kimo sedang bernapas, \(viewModel.currentPhase.rawValue), ikuti gerakan Kimo",
                        isDecorative: false,
                        identifier: "breathing.kimoAnimation"
                    )
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
            .kimoTextGroupAccessibility(
                combinedLabel: "Instruksi pernapasan: \(viewModel.currentPhase.rawValue). Waktu tersisa: \(viewModel.remainingTime) detik.",
                identifier: "breathing.instruction",
                sortPriority: 2)
            
            // Start/Stop button
            Button(action: {
                if viewModel.isActive {
                    viewModel.stopBreathing()
                    accessibilityManager.announce("Latihan pernapasan dihentikan")
                } else {
                    viewModel.startBreathing()
                    accessibilityManager.announce("Latihan pernapasan dimulai. Ikuti instruksi Kimo")
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
            .kimoButtonAccessibility(
                label: viewModel.isActive ? "Berhenti" : "Mulai latihan pernapasan",
                hint: viewModel.isActive ? "Ketuk dua kali untuk menghentikan latihan pernapasan" : "Ketuk dua kali untuk memulai latihan pernapasan bersama Kimo",
                identifier: "breathing.controlButton"
            )
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
                    .kimoButtonAccessibility(
                        label: "Kimo maskot kecil",
                        hint: "Ketuk dua kali untuk berinteraksi dengan Kimo",
                        identifier: "breathing.kimoMascot"
                    )
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
                .kimoImageAccessibility(
                    label: "Kimo selesai latihan pernapasan",
                    isDecorative: false,
                    identifier: "breathing.completion.kimo"
                )
                
                // Question text
                Text("Apa yang kamu rasakan ketika tarik nafas?")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(ColorToken.textSecondary.toColor())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .kimoTextAccessibility(
                        label: "Pertanyaan refleksi: Apa yang kamu rasakan ketika tarik nafas?",
                        identifier: "breathing.completion.question",
                        sortPriority: 1
                    )
                
                // Action buttons
                HStack(spacing: 20) {
                    // Play again button
                    Button(action: {
                        viewModel.restartBreathing()
                        accessibilityManager.announce("Latihan pernapasan dimulai ulang")
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
                    .kimoButtonAccessibility(
                        label: "Mulai Lagi",
                        hint: "Ketuk dua kali untuk mengulang latihan pernapasan dari awal",
                        identifier: "breathing.completion.restart"
                    )
                    
                    // Continue button
                    Button(action: {
                        viewModel.finishSession()
                        accessibilityManager.announce("Melanjutkan ke aktivitas berikutnya")
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
                    .kimoButtonAccessibility(
                        label: "Lanjutkan",
                        hint: "Ketuk dua kali untuk melanjutkan ke aktivitas berikutnya",
                        identifier: "breathing.completion.continue"
                    )
                }
                .padding(.horizontal, 20)
            }
            .padding(30)
            .background(ColorToken.additionalColorsWhite.toColor())
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
        .onAppear {
            // Announce completion dialog appearance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                accessibilityManager.announceScreenChange("Latihan pernapasan selesai. Apa yang kamu rasakan ketika tarik nafas?")
            }
        }
    }
}

#Preview {
    BreathingModuleView(onCompletion: {
        print("Breathing exercise completed")
    })
}
