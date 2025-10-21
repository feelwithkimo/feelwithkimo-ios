//
//  DetectSoundsView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/10/25.
//
import Foundation
import SwiftUI
import SoundAnalysis

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
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .accessibilityAddTraits(.isHeader)
                        
                        Text("Uji dan kalibrasi sistem deteksi napas")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Main Detection Status
                    VStack(spacing: 16) {
                        HStack {
                            Circle()
                                .fill(breathDetector.isDetecting ? Color.green : Color.gray)
                                .frame(width: 12, height: 12)
                            Text("Status: \(breathDetector.isDetecting ? "Mendeteksi" : "Berhenti")")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Jenis Napas: \(breathTypeText)")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(breathTypeColor)
                            
                            Text("Kepercayaan: \(Int(breathDetector.breathingConfidence * 100))%")
                                .font(.body)
                            
                            Text("Audio Level: \(String(format: "%.3f", breathDetector.audioLevel))")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            // Audio level visualization
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.blue)
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
                    .background(Color.gray.opacity(0.1))
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
                        }) {
                            Text(breathDetector.isDetecting ? "Stop Deteksi" : "Mulai Deteksi")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(breathDetector.isDetecting ? Color.red : Color.green)
                                .cornerRadius(12)
                        }
                        .accessibilityLabel(breathDetector.isDetecting ? "Hentikan deteksi napas" : "Mulai deteksi napas")
                        
                        Button(action: {
                            voiceManager.speak("Sekarang coba tarik napas dalam-dalam, lalu hembuskan perlahan")
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .accessibilityLabel("Panduan suara untuk latihan napas")
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instruksi:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "1.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Tekan 'Mulai Deteksi' untuk memulai")
                                    .font(.body)
                            }
                            
                            HStack {
                                Image(systemName: "2.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Tarik napas dalam-dalam melalui hidung")
                                    .font(.body)
                            }
                            
                            HStack {
                                Image(systemName: "3.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Hembuskan napas perlahan melalui mulut")
                                    .font(.body)
                            }
                            
                            HStack {
                                Image(systemName: "4.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Perhatikan deteksi 'Menghirup' dan 'Menghembuskan'")
                                    .font(.body)
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
                    }) {
                        HStack {
                            Text(showingDebugInfo ? "Sembunyikan Info Debug" : "Tampilkan Info Debug")
                            Image(systemName: showingDebugInfo ? "chevron.up" : "chevron.down")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
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
        .onChange(of: breathDetector.currentBreathType) { newBreathType in
            handleBreathTypeChange(newBreathType)
        }
    }
    
    private var debugSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informasi Debug SoundAnalysis")
                .font(.headline)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Label Terkait Pernapasan (\(breathingRelatedLabels.count)):")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                if breathingRelatedLabels.isEmpty {
                    Text("Loading...")
                        .foregroundColor(.gray)
                } else {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(breathingRelatedLabels, id: \.self) { label in
                            Text("• \(label)")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Semua Label Tersedia (\(allLabels.count)):")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(allLabels, id: \.self) { label in
                            Text("• \(label)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
            
            Text("Gunakan informasi ini untuk memahami kategori suara yang tersedia dalam SoundAnalysis framework Apple.")
                .font(.caption)
                .foregroundColor(.gray)
                .italic()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
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
