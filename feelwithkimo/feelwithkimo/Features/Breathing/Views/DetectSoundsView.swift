//
//  DetectSoundsView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import SoundAnalysis
import SwiftUI

struct DetectSoundsView: View {
    @StateObject private var breathDetector = BreathDetectionManager()
    @StateObject private var voiceManager = VoiceInstructionManager()
    @State private var showingDebugInfo = false
    @State private var allLabels: [String] = []
    @State private var breathingRelatedLabels: [String] = []
    @State private var previousBreathType: BreathType = .none

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Deteksi Suara Napas")
                            .font(.app(.largeTitle, family: .primary))
                            .accessibilityAddTraits(.isHeader)

                        Text("Uji dan kalibrasi sistem deteksi napas")
                            .font(.app(.subheadline, family: .primary))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    // Main Detection Status
                    VStack(spacing: 16) {
                        HStack {
                            Circle()
                                .fill(breathDetector.isDetecting ? Color.green : Color.gray)
                                .frame(width: 12, height: 12)
                            Text("Status: \(breathDetector.isDetecting ? "Mendeteksi" : "Berhenti")")
                                .font(.app(.headline, family: .primary))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Jenis Napas: \(breathTypeText)")
                                .font(.app(.title2, family: .primary))
                                .foregroundStyle(breathTypeColor)

                            Text("Kepercayaan: \(Int(breathDetector.breathingConfidence * 100))%")
                                .font(.app(.body, family: .primary))

                            Text("Audio Level: \(String(format: "%.3f", breathDetector.audioLevel))")
                                .font(.app(.body, family: .primary))
                                .foregroundStyle(ColorToken.textSecondary.toColor())

                            // Audio level visualization
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(ColorToken.grayscale30.toColor())
                                        .frame(height: 8)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(ColorToken.emotionSadness.toColor())
                                        .frame(
                                            width: geometry.size.width * min(breathDetector.audioLevel * 20, 1.0),
                                            height: 8
                                        )
                                }
                            }
                            .frame(height: 8)
                        }
                    }
                    .padding()
                    .background(ColorToken.grayscale10.toColor())
                    .cornerRadius(15)

                    // Control Buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            if breathDetector.isDetecting {
                                breathDetector.stopDetection()
                                voiceManager.speak("Deteksi dihentikan")
                            } else {
                                breathDetector.startDetection()
                                voiceManager.speak("Mulai deteksi napas. Coba tarik napas dalam-dalam.")
                            }
                        }, label: {
                            Text(breathDetector.isDetecting ? "Stop Deteksi" : "Mulai Deteksi")
                                .font(.app(.title3, family: .primary))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(breathDetector.isDetecting ? Color.red : Color.green)
                                .cornerRadius(12)
                        })
                        .accessibilityLabel(breathDetector.isDetecting ? "Hentikan deteksi napas" : "Mulai deteksi napas")

                        Button(action: {
                            voiceManager.speak("Sekarang coba tarik napas dalam-dalam, lalu hembuskan perlahan")
                        }, label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.app(.title2, family: .primary))
                                .foregroundStyle(ColorToken.additionalColorsWhite.toColor())
                                .frame(width: 50, height: 50)
                                .background(ColorToken.emotionSadness.toColor())
                                .cornerRadius(12)
                        })
                        .accessibilityLabel("Panduan suara untuk latihan napas")
                    }

                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instruksi:")
                            .font(.app(.headline, family: .primary))

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "1.circle.fill")
                                    .foregroundStyle(ColorToken.emotionSadness.toColor())
                                Text("Tekan 'Mulai Deteksi' untuk memulai")
                                    .font(.app(.body, family: .primary))
                            }

                            HStack {
                                Image(systemName: "2.circle.fill")
                                    .foregroundStyle(ColorToken.emotionSadness.toColor())
                                Text("Tarik napas dalam-dalam melalui hidung")
                                    .font(.app(.body, family: .primary))
                            }

                            HStack {
                                Image(systemName: "3.circle.fill")
                                    .foregroundStyle(.blue)
                                Text("Hembuskan napas perlahan melalui mulut")
                                    .font(.app(.body, family: .primary))
                            }

                            HStack {
                                Image(systemName: "4.circle.fill")
                                    .foregroundStyle(.blue)
                                Text("Perhatikan deteksi 'Menghirup' dan 'Menghembuskan'")
                                    .font(.app(.body, family: .primary))
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    // Debug Toggle
                    Button(action: {
                        showingDebugInfo.toggle()
                        if showingDebugInfo {
                            loadDebugLabels()
                        }
                    }, label: {
                        HStack {
                            Text(showingDebugInfo ? "Sembunyikan Info Debug" : "Tampilkan Info Debug")
                            Image(systemName: showingDebugInfo ? "chevron.up" : "chevron.down")
                        }
                        .padding()
                        .background(ColorToken.grayscale20.toColor())
                        .cornerRadius(8)
                    })

                    // Debug Information
                    if showingDebugInfo {
                        debugSection
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            voiceManager.speak("Halaman deteksi suara napas. Gunakan halaman ini untuk menguji sistem deteksi.")
        }
        .onChange(of: breathDetector.currentBreathType) { _, newBreathType in
            handleBreathTypeChange(newBreathType)
        }
    }

    private var debugSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informasi Debug SoundAnalysis")
                .font(.app(.headline, family: .primary))
                .foregroundStyle(ColorToken.coreSecondary.toColor())

            VStack(alignment: .leading, spacing: 10) {
                Text("Label Terkait Pernapasan (\(breathingRelatedLabels.count)):")
                    .font(.app(.subheadline, family: .primary))
                    .foregroundStyle(ColorToken.emotionSadness.toColor())

                if breathingRelatedLabels.isEmpty {
                    Text("Loading...")
                        .foregroundStyle(ColorToken.grayscale100.toColor())
                } else {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(breathingRelatedLabels, id: \.self) { label in
                            Text("• \(label)")
                                .font(.app(.caption1, family: .primary))
                                .foregroundStyle(ColorToken.textPrimary.toColor())
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 10) {
                Text("Semua Label Tersedia (\(allLabels.count)):")
                    .font(.app(.subheadline, family: .primary))
                    .foregroundStyle(ColorToken.grayscale100.toColor())

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(allLabels, id: \.self) { label in
                            Text("• \(label)")
                                .font(.app(.caption2, family: .primary))
                                .foregroundStyle(ColorToken.textSecondary.toColor())
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            .padding()
            .background(ColorToken.grayscale10.toColor())
            .cornerRadius(8)

            Text("Gunakan informasi ini untuk memahami kategori suara yang tersedia dalam SoundAnalysis framework Apple.")
                .font(.app(.caption1, family: .primary))
                .foregroundStyle(ColorToken.grayscale100.toColor())
                .italic()
        }
        .padding()
        .background(ColorToken.backgroundMain.toColor())
        .cornerRadius(12)
    }

    private var breathTypeText: String {
        switch breathDetector.currentBreathType {
        case .inhale:
            return "Menghirup"
        case .exhale:
            return "Menghembuskan"
        case .none:
            return "Tidak terdeteksi"
        }
    }

    private var breathTypeColor: Color {
        switch breathDetector.currentBreathType {
        case .inhale:
            return .blue
        case .exhale:
            return .green
        case .none:
            return .gray
        }
    }

    private func handleBreathTypeChange(_ newBreathType: BreathType) {
        // Only provide voice feedback if the breath type actually changed
        guard newBreathType != previousBreathType else { return }

        switch newBreathType {
        case .inhale:
            voiceManager.speak("Menghirup terdeteksi")
        case .exhale:
            voiceManager.speak("Menghembuskan terdeteksi")
        case .none:
            // Don't announce when breathing stops to avoid too much chatter
            break
        }

        previousBreathType = newBreathType
    }

    private func loadDebugLabels() {
        do {
            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            allLabels = request.knownClassifications.sorted()
            breathingRelatedLabels = BreathDetectionManager.getBreathingRelatedLabels().sorted()
        } catch {
            print("❌ Error loading debug labels: \(error)")
        }
    }
}

#Preview {
    DetectSoundsView()
}
