//
//  KimoProgressBar.swift
//  feelwithkimo
//
//  Created by jonathan calvin sutrisna on 03/11/25.
//
import SwiftUI

/**
 * Komponen Progress Bar kustom yang meniru desain pada gambar.
 * Menggunakan ZStack dengan dua Capsule untuk track dan progress.
 * Disandingkan dengan Text dalam sebuah HStack.
 */
struct KimoProgressBar: View {
    var value: Double
    
    var barHeight: CGFloat = 25
    var trackColor: Color = ColorToken.additionalColorsWhite.toColor()
    var progressColor: Color = ColorToken.corePrimary.toColor()

    var body: some View {
        HStack(spacing: 15) {
            GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                    Capsule()
                        .fill(trackColor)
                    Capsule()
                        .fill(progressColor)
                        .frame(width: geometry.size.width * value)
                }
                .frame(height: barHeight)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .frame(height: barHeight)
        }
        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
