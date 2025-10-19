//
//  HomeViewModel.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 19/10/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
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
        self.currentUser = UserManager.shared.getCurrentUser()
        
        // Data dummy untuk daftar emosi
        self.emotions = [
            EmotionModel(id: UUID(), name: "Seneng", visualCharacterName: "face.smiling"),
            EmotionModel(id: UUID(), name: "Marah", visualCharacterName: "face.dashed"),
            EmotionModel(id: UUID(), name: "Sedih", visualCharacterName: "face.rolling.eyes"),
            EmotionModel(id: UUID(), name: "Kaget", visualCharacterName: "figure.mind.and.body"),
            EmotionModel(id: UUID(), name: "Takut", visualCharacterName: "figure.walk.motion")
        ]
    }
    
    // MARK: - Public Methods
    
    /// Mengatur emosi yang dipilih oleh pengguna.
    /// Dipanggil dari View ketika pengguna mengetuk salah satu kartu emosi.
    /// - Parameter emotion: Emosi yang dipilih.
    func selectEmotion(_ emotion: EmotionModel) {
        selectedEmotion = emotion
    }
}
