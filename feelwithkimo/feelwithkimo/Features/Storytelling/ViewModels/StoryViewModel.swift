//
//  StoryViewModel.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import Foundation
import SwiftUI

internal class StoryViewModel: ObservableObject {
    @AppStorage("hasSeenTutorial") var hasSeenTutorial = false
    @Published var hasSeenTutor: Bool = false
    
    @Published var index: Int = 0
    @Published var currentScene: StorySceneModel = StorySceneModel(
        path: "Scene 1",
        text: "Hi aku Lala​",
        isEnd: false,
        interactionType: .normal
    )
    @Published var hasCompletedBreathing: Bool = false
    @Published var hasCompletedClapping: Bool = false
    @Published var tutorialStep: Int = 1
    
    @Published var showDialogue: Bool = false
    var isTappedMascot: Bool = false

    lazy var story: StoryModel = StoryModel(
        id: UUID(),
        name: "Story Angry 1",
        thumbnail: "Thumbnail 1",
        description: "Description",
        storyScene: []
    )

    init() {
        fetchStory()
    }

    /// Load story scene
    private func fetchStory() {
        let scenes: [StorySceneModel] = [
            StorySceneModel(path: "Scene 1", text: "Pagi yang cerah, Lala sedang bermain balok warna-warni.", nextScene: [1]),
            StorySceneModel(path: "Scene 2",
                            text: "Tiba-tiba… bruk! Lala menyenggol menaranya hingga jatuh! Balok-baloknya berhamburan ke mana-mana.",
                            nextScene: [0, 2], kimoVisual: .star, kimoText: "Wah, sayang sekali!"),
            StorySceneModel(path: "Scene 3", text: "Wajah Lala berubah! Pertama, matanya membesar, mulutnya menganga...",
                            nextScene: [1, 3],
                            kimoVisual: .star,
                            kimoText: "Wah, Lala merasa kaget!"),
            StorySceneModel(path: "Scene 4",
                            text: "Lalu, pipi Lala memerah, alisnya mengerut, dan bibirnya manyun!",
                            nextScene: [2, 4],
                            kimoVisual: .star,
                            kimoText: "Sekarang, Lala merasa kesal!"),
            StorySceneModel(path: "Scene 5",
                            text: "Awal-awal, Lala kaget. Kemudian, ia marah!",
                            nextScene: [3, 5],
                            kimoVisual: .star,
                            kimoText: "Tadi itu adalah ekspresi Lala pas marah. Kalau ekspresimu pas marah gimana?"),
            StorySceneModel(path: "Scene 6",
                            text: "Lala bangun perlahan...\n“Huuuuh! Kok jatuh sih! Aku udah susun lama-lama! Huuuh!” katanya keras-keras.",
                            nextScene: [4, 6]),
            StorySceneModel(path: "Scene 6",
                            text: "Lala bangun perlahan...\n“Huuuuh! Kok jatuh sih! Aku udah susun lama-lama! Huuuh!” katanya keras-keras.",
                            question: QuestionOption(question: "Wah, Lala marah sekali! Menurutmu di sini, apa yang sebaiknya Lala lakukan?",
                                                     option: ["Mengambek", "Minta bantuan Ibu"]),
                            nextScene: [5, 7, 21],
                            interactionType: .storyBranching),
            StorySceneModel(path: "Scene 7",
                            text: "BRUK! Lala semakin ngambek! Ia memukul, melempar, dan menendang baloknya. Tapi… aah! Kakinya jadi sakit!",
                            nextScene: [6, 8],
                            kimoVisual: .star,
                            kimoText: "Oh tidak! Kakinya Lala malah sakit… dan sekarang baloknya malah berantakan."),
            
            StorySceneModel(path: "Scene 8",
                            text: "Ibu masuk ke dalam kamar Lala. Ia berlutut sejajar dengan Lala. ‘Lala sayang, abis nendang-nendang, ya?’ tanya Ibu dengan suara lembut.",
                            nextScene: [7, 9]),
            StorySceneModel(path: "Scene 9", text: "Lala mengangguk pelan.", nextScene: [8, 10]),
            StorySceneModel(path: "Scene 10", text: "\"Lala kenapa?\" tanya Ibu kepada Lala", nextScene: [9, 11]),
            StorySceneModel(path: "Scene 11",
                            text: "\"Tadi Lala lagi nyusun balok... Udah tinggi, bu. Tapi, menaranya jatuh!\"",
                            nextScene: [10, 12]),
            StorySceneModel(path: "Scene 12",
                            text: "Ibu memeluk Lala dan berkata: \"Di saat ada sesuatu yang tidak sesuai dengan kemauan Lala, terus Lala cemberut... Itu namanya marah." +
                            " Marah itu artinya tubuhmu sedang bilang, 'Aku nggak suka!'\"",
                            nextScene: [11, 13],
                            kimoVisual: .star,
                            kimoText: "Wah, ternyata tubuh kita bisa memberi tahu perasaan kita!"),
            StorySceneModel(path: "Scene 13",
                            text: "“Kalau tubuh Lala bilang ‘aku nggak suka,’ yuk kita tenangkan dulu. Lala ikuti ibu, ya.”" +
                            " Ibu menarik napas panjang… “Haaa…” Lalu menghembuskannya,“Fuuuh…”",
                            nextScene: [12, 14]),
            StorySceneModel(path: "Scene 14",
                            text: "Lala menarik napas dalam… “Haaa… Fuuuh... Haaa... Fuuuh...” Wah, api di hati Lala perlahan mengecil! Sekarang dadanya lebih sejuk, seperti" +
                            " ditiup angin.",
                            nextScene: [13, 15],
                            kimoVisual: .star,
                            kimoText: "Ketika Lala menarik napas pelan, api marahnya mengecil. Kira-kira kalau kita napas pelan juga… apa yang akan terjadi di tubuh kita ya?" +
                            " Yuk, coba bareng Kimo!"),
            StorySceneModel(path: "Scene 14",
                            text: "Lala menarik napas dalam… “Haaa… Fuuuh... Haaa... Fuuuh...” Wah, api di hati Lala perlahan mengecil! Sekarang dadanya lebih sejuk, seperti" +
                            " ditiup angin.",
                            nextScene: [14, 16],
                            interactionType: .breathing,
                            kimoVisual: .star,
                            kimoText: "Ketika Lala menarik napas pelan, api marahnya mengecil. Kira-kira kalau kita napas pelan juga… apa yang akan terjadi di tubuh kita ya?" +
                            " Yuk, coba bareng Kimo!"),
            
            StorySceneModel(path: "Scene 15",
                            text: "Ibu ”Nah, karena Lala udah merasa mendingan... Yuk, kita coba lagi. Sini, ibu bantu Lala susun ulang balok-baloknya.“",
                            nextScene: [15, 17]),
            StorySceneModel(path: "Scene 16",
                            text: "Lala dan ibu mengambil baloknya lagi. Pelan-pelan, mereka mulai membangun menara baru.",
                            nextScene: [16, 18],
                            kimoVisual: .star,
                            kimoText: "Wah, Lala mulai kembali menyusun balok! Semangat, Lala! Aku yakin kamu bisa!"),
            StorySceneModel(path: "Scene 17",
                            text: "Dan… lihat! Menaranya bahkan menjadi lebih tinggi dari sebelumnya! Lala bertepuk tangan gembira, dan Ibu pun ikut. Yeay!",
                            nextScene: [17, 19],
                            kimoVisual: .star,
                            kimoText: "Hore, Lala berhasil! Kalau senang, kita tepuk tepuk! Ayo, kita tepuk tangan bersama!"),
            StorySceneModel(path: "Scene 17", text: "Dan… lihat! Menaranya bahkan menjadi lebih tinggi dari sebelumnya! Lala bertepuk tangan gembira, dan Ibu pun ikut. Yeay!",
                            nextScene: [18, 20],
                            interactionType: .clapping,
                            kimoVisual: .star,
                            kimoText: "Hore, Lala berhasil! Kalau senang, kita tepuk tepuk! Ayo, kita tepuk tangan bersama!"),
            
            StorySceneModel(path: "Scene 18",
                            text: "Kadang kita bisa marah. Apalagi saat ada sesuatu yang tidak seperti yang kita mau. Yang penting… kita bisa belajar untuk menenangkan diri." +
                            " Marahnya kita tiup-tiup! Fuh, fuh, fuh! Dan, coba lagi terus, pelan-pelan!",
                            isEnd: true,
                            nextScene: [19, 21],
                            kimoVisual: .star,
                            kimoText: "Sekarang kita tahu, kalau suatu saat kamu marah lagi… kamu bisa tarik napas pelan seperti tadi! Yeay!"),
            StorySceneModel(path: "Scene 7_B",
                            text: "Lala duduk dengan muka yang cemberut. Tangannya menyilang. ‘Ibuuu, ibuuuu!’ panggil Lala.",
                            nextScene: [6, 22]),
            StorySceneModel(path: "Scene 8_B",
                            text: "Ibu masuk ke dalam kamar Lala. Ia berlutut sejajar dengan Lala. “Lala sayang, abis memanggil ibu ya?“ tanya Ibu dengan suara lembut.",
                            nextScene: [21, 9])
        ]

        self.story.storyScene = scenes
        self.currentScene = self.story.storyScene[0]
    }

    /// Function to next and previous scene of story
    func goScene(to number: Int, choice: Int = 0) {
        switch number {
        case 1:
            guard !self.currentScene.isEnd else { return }

            // Next scene for first scene since the first scene has no previous scene the index will be 0 instead of 1
            if self.currentScene.path == story.storyScene[0].path {
                self.currentScene = self.story.storyScene[1]
            } else {
                self.currentScene = choice == 0 ? self.story.storyScene[self.currentScene.nextScene[1]] : self.story.storyScene[self.currentScene.nextScene[2]]
            }
            self.showDialogue = false
            self.isTappedMascot = false
            self.index += 1
            
        // Previous Scene
        case -1:
            guard self.currentScene.nextScene.count > 1 else { return }

            self.currentScene = self.story.storyScene[self.currentScene.nextScene[0]]
            self.showDialogue = false
            self.isTappedMascot = false
            self.index -= 1
        default:
            break
        }
    }
    
    /// Mark breathing exercise as completed and move to next scene
    func completeBreathingExercise() {
        hasCompletedBreathing = true
        goScene(to: 1, choice: 0)
    }

    /// Mark clapping exercise as completed
    func completeClappingExercise() {
        hasCompletedClapping = true
        goScene(to: 1, choice: 0)
    }
    
    func nextTutorial() {
        guard self.tutorialStep < 3 else {
            DispatchQueue.main.async {
                self.hasSeenTutorial = true
                self.hasSeenTutor = true
            }
            return
        }
        
        DispatchQueue.main.async {
            self.tutorialStep += 1
        }
    }
  
    func replayStory() {
        DispatchQueue.main.async {
            self.index = 0
            self.currentScene = self.story.storyScene[0]
            self.hasCompletedBreathing = false
            self.hasCompletedClapping = false
        }
    }
}
