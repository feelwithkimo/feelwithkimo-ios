//
//  BalloonsSectionView.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 25/10/25.
//

import SwiftUI

struct BalloonsSectionView: View {
    @ObservedObject var gameState: GameStateManager
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Text("Ayah/Ibu")
                    .font(.app(.caption1, family: .primary))
                    .foregroundStyle(
                        gameState.currentPlayer == .parent && gameState.isGameActive ? .red : .gray
                    )
                BalloonView(
                    progress: gameState.parentBalloonProgress,
                    color: .red,
                    isActive: gameState.currentPlayer == .parent && gameState.isGameActive
                )
                .scaleEffect(
                    gameState.currentPlayer == .parent && gameState.isGameActive ? 1.1 : 1.0
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer == .parent)
                if gameState.currentPlayer == .parent && gameState.isGameActive {
                    Text("🎈 GILIRANMU!")
                        .font(.app(.caption2, family: .primary))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: gameState.isGameActive
                        )
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Balon merah untuk ayah atau ibu")
            .accessibilityValue(
                "Progress \(Int(gameState.parentBalloonProgress)) persen, \(gameState.currentPlayer == .parent && gameState.isGameActive ? "aktif, giliran meniup sekarang" : "menunggu giliran")"
            )
            if gameState.isGameActive {
                VStack {
                    Text("🐘").font(.app(.title1, family: .primary)).scaleEffect(1.2)
                    Text("Kimo").font(.app(.caption2, family: .primary)).foregroundStyle(.gray)
                }
            }
            VStack {
                Text("Anak")
                    .font(.app(.caption1, family: .primary))
                    .foregroundStyle(
                        gameState.currentPlayer == .child && gameState.isGameActive ? .blue : .gray
                    )
                BalloonView(
                    progress: gameState.childBalloonProgress,
                    color: .blue,
                    isActive: gameState.currentPlayer == .child && gameState.isGameActive
                )
                .scaleEffect(
                    gameState.currentPlayer == .child && gameState.isGameActive ? 1.1 : 1.0
                )
                .animation(.easeInOut(duration: 0.3), value: gameState.currentPlayer == .child)
                if gameState.currentPlayer == .child && gameState.isGameActive {
                    Text("🎈 GILIRANMU!")
                        .font(.app(.title1, family: .primary))
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: gameState.isGameActive
                        )
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Balon biru untuk anak")
            .accessibilityValue(
                "Progress \(Int(gameState.childBalloonProgress)) persen, \(gameState.currentPlayer == .child && gameState.isGameActive ? "aktif, giliran meniup sekarang" : "menunggu giliran")"
            )
        }
        .accessibilityElement(children: .ignore)
    }
}
