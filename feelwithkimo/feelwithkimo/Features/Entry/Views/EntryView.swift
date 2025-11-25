//
//  EntryView.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 05/11/25.
//

import SwiftUI

struct EntryView: View {
    @StateObject private var accessibilityManager = AccessibilityManager.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    mainBackgroundView(geometry: geometry)
                    mainEntryView(geometry: geometry)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Selamat datang di aplikasi Kimo. Halaman pembuka siap digunakan.")
            }
        }
    }
    
    private func mainEntryView(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                
                Text("Entry_Title_1", comment: "")
                    .font(.customFont(size: 34, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .padding(.bottom, geometry.size.height * 0.01)
                
                KimoImage(image: "Kimo-Pink-Wave", width: geometry.size.width * 0.51)
                
                Text("Entry_Title_2", comment: "")
                    .font(.customFont(size: 28, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .frame(maxWidth: 356.getWidth())
                    .multilineTextAlignment(.trailing)
                    .padding(.top, geometry.size.height * 0.006)
                
                NavigationLink {
                    OldEmotionStoryView(viewModel: EmotionStoryViewModel(path: "Balok"))
                } label: {
                    KimoBubbleButtonPrimary(
                        buttonLabel: NSLocalizedString("Lets_Start", comment: "")
                    )
                }
                .padding(.top, geometry.size.height * 0.084)
                
                Spacer()
            }
            .padding(.trailing, geometry.size.width * 0.067)
            .offset(y: -geometry.size.height * 0.096)
        }
    }

    private func mainBackgroundView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .bottomLeading) {
            KimoEllipseView()
                .offset(y: geometry.size.height * 0.675)
            
            Image("KimoSchool")
                .resizable()
                .scaledToFit()
                .frame(width: 800.getWidth())

        }
    }
}

#Preview {
    EntryView()
}
