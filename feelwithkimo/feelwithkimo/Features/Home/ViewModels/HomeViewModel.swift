//
//  HomeViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Combine
import Foundation
import SwiftUI

internal class HomeViewModel: ObservableObject {
    @AppStorage("identity") var identity: String = ""

    // MARK: - Published Properties
    @Published var currentUser: UserModel?
    @Published var emotions: [EmotionModel] = []
    @Published var selectedEmotion: EmotionModel?

    // MARK: - Lifecycle
    init() {
        fetchData()
    }

    // MARK: - Private Methods

    /// Mengambil semua data yang diperlukan untuk Home View.
    /// Fungsi ini memanggil manager untuk mendapatkan data user dan menyiapkan daftar emosi.
    private func fetchData() {
        self.currentUser = UserModel(id: UUID(), name: identity)

        // Data dummy untuk daftar emosi
        self.emotions = [
            EmotionModel(id: UUID(), name: "Seneng", visualCharacterName: "face.smiling", emotionImage: "", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Sedih", visualCharacterName: "face.rolling.eyes", emotionImage: "", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Marah", visualCharacterName: "face.dashed", emotionImage: "Anger", title: "Hi, aku marah",
                         description: "Aku gampang kesal kalau sesuatu tidak adil, tapi belajar menarik napas dan bicara baik-baik.", stories: []),
            EmotionModel(id: UUID(), name: "Kaget", visualCharacterName: "figure.mind.and.body", emotionImage: "", title: "", description: "", stories: []),
            EmotionModel(id: UUID(), name: "Takut", visualCharacterName: "figure.walk.motion", emotionImage: "", title: "", description: "", stories: [])
        ]

        self.selectedEmotion = emotions.first(where: { $0.name == "Sedih" })
    }

    // MARK: - Public Methods

    /// Mengatur emosi yang dipilih oleh pengguna.
    /// Dipanggil dari View ketika pengguna mengetuk salah satu kartu emosi.
    /// - Parameter emotion: Emosi yang dipilih.
    func selectEmotion(_ emotion: EmotionModel) {
        guard selectedEmotion?.id != emotion.id else { return }
        selectedEmotion = emotion
    }

    /// Update emosi terdekat berdasarkan posisi tengah layar
    func updateSelectedEmotion(screenCenterX: CGFloat, centers: [AnyHashable: CGFloat]) {
        guard !centers.isEmpty else { return }

        if let (closestId, _) = centers.min(by: { abs($0.value - screenCenterX) < abs($1.value - screenCenterX) }),
           let matched = emotions.first(where: { AnyHashable($0.id) == closestId }) {
            selectEmotion(matched)
        }
    }

    /// Scroll ke emosi yang dipilih
    func scrollToSelected(proxy: ScrollViewProxy) {
        guard let selected = selectedEmotion else { return }
        withAnimation {
            proxy.scrollTo(selected.id, anchor: .center)
        }
    }

    /// Pastikan ada emosi awal yang dipilih
    func ensureInitialSelection() {
        if selectedEmotion == nil, !emotions.isEmpty {
            let midIndex = emotions.count / 2
            selectedEmotion = emotions[midIndex]
        }
    }

    /// Buat destination view untuk NavigationLink
    func makeEmotionStoryView(for emotion: EmotionModel) -> some View {
        EmotionStoryView(viewModel: EmotionStoryViewModel(emotion: emotion))
    }
}
