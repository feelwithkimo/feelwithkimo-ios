//
//  IdentityView.swift
//  
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct IdentityView: View {
    @StateObject var viewModel: IdentityViewModel = IdentityViewModel()
    @StateObject private var accessibilityManager = AccessibilityManager.shared

    var body: some View {
        GeometryReader { geometry in
            if viewModel.identity == "" || viewModel.parentNickname == "" {
                ZStack {
                    // Background color
                    ColorToken.emotionSadness.toColor()
                        .ignoresSafeArea()
                    
                    // Ellipse decorations
                    ellipseView(geometry: geometry)
                    
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            titleView
                            
                            kimoMascotView
                                .frame(width: 485.getWidth(), height: 470.getHeight())
                                .offset(x: geometry.size.width * 0.035)
                            
                        }
                        .padding(.leading, 59.getWidth())
                        .zIndex(1)
                        
                        VStack(alignment: .trailing, spacing: 73) {
                            
                            Spacer()
                            
                            textFieldView
                                .frame(maxWidth: 600.getWidth())
                            
                            submitButtonView
                                .offset(x: -geometry.size.width * 0.002)
                        }
                        .padding(.trailing, 82.getWidth())
                        .padding(.bottom, 70.getHeight())
                    }
                }
                .onAppear {
                    // Announce screen when it appears
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        accessibilityManager.announceScreenChange("Halaman pengisian identitas")
                    }
                }
                .navigationBarBackButtonHidden(true)
            } else {
                HomeView()
            }
        }
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Kenalan")
                .font(.customFont(size: 104, weight: .bold))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
            
            Text("Yuk!")
                .font(.customFont(size: 104, weight: .bold))
                .foregroundStyle(ColorToken.backgroundSecondary.toColor())
        }
        .kimoTextAccessibility(
            label: "Isi identitas",
            identifier: "identity.parentTitle",
            sortPriority: 1
        )
    }
    
    private func ellipseView(geometry: GeometryProxy) -> some View {
        ZStack {
            // Top-left ellipse
            Ellipse()
                .fill(ColorToken.backgroundIdentity.toColor())
                .frame(width: 651.getWidth(), height: 591.getHeight())
                .offset(x: -geometry.size.width * 0.30, y: -geometry.size.height * 0.35)
            
            // Top-right ellipse
            Ellipse()
                .fill(ColorToken.backgroundIdentity.toColor())
                .frame(width: 651.getWidth(), height: 591.getHeight())
                .offset(x: geometry.size.width * 0.35, y: -geometry.size.height * 0.5)
            
            // Bottom-left ellipse
            Ellipse()
                .fill(ColorToken.backgroundIdentity.toColor())
                .frame(width: 651.getWidth(), height: 591.getHeight())
                .offset(x: -geometry.size.width * 0.225, y: geometry.size.height * 0.5)
            
            // Bottom-right ellipse
            Ellipse()
                .fill(ColorToken.backgroundIdentity.toColor())
                .frame(width: 500.getWidth(), height: 500.getHeight())
                .offset(x: geometry.size.width * 0.35, y: geometry.size.height * 0.45)
        }
    }
    
    private var kimoMascotView: some View {
        Image("Kimo-Pencil")
            .resizable()
            .scaledToFit()
            .kimoImageAccessibility(
                label: "Kimo, karakter utama aplikasi",
                isDecorative: false,
                identifier: "entry.kimoCharacter"
            )
    }
    
    private var textFieldView: some View {
        ZStack {
            // Background image
            Image("Iden-Rounded-Rect")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 100))
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .fill(
                            Color.clear
                                .shadow(.inner(
                                    color: ColorToken.backgroundSecondary.toColor().opacity(0.5),
                                    radius: 2.0,
                                    x: 5,
                                    y: -3
                                ))
                                .shadow(.drop(
                                    color: ColorToken.backgroundSecondary.toColor().opacity(0.5),
                                    radius: 20.0,
                                    x: 0,
                                    y: 4
                                ))
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 100))
            
            // Content
            VStack(alignment: .leading, spacing: 0) {
                Text("Nama Panggilan untuk si Kecil:")
                    .font(.customFont(size: 22, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .padding(.bottom, 8)
                    .kimoTextAccessibility(
                        label: "Nama si kecil",
                        identifier: "identity.nicknameChildLabel",
                        sortPriority: 2
                    )
                
                KimoTextField(placeholder: "Misal: Lala", inputText: $viewModel.childNicknameInput)
                    .kimoAccessibility(
                        label: "Kolom nama anak",
                        hint: "Masukkan nama anak",
                        traits: .isButton,
                        identifier: "identity.nicknameChildField",
                        sortPriority: 3
                    )
                
                Text(viewModel.errorMessageChild)
                    .font(.customFont(size: 16, family: .primary, weight: .regular))
                    .foregroundStyle(viewModel.showErrorChild ? ColorToken.emotionAnger.toColor() : Color.clear)
                    .padding(.top, 4)
                    .kimoTextAccessibility(
                        label: viewModel.showErrorChild ? viewModel.errorMessageChild : "",
                        identifier: "identity.errorMessageChild",
                        sortPriority: 4
                    )
                
                Text("Nama Panggilan untuk Orang Tua:")
                    .font(.customFont(size: 22, family: .primary, weight: .bold))
                    .foregroundStyle(ColorToken.backgroundSecondary.toColor())
                    .padding(.bottom, 8)
                    .kimoTextAccessibility(
                        label: "Nama Panggilan untuk Orang Tua:",
                        identifier: "identity.nicknameLabel",
                        sortPriority: 5
                    )
                    .padding(.top, 8)
                
                KimoTextField(placeholder: "Misal: Ibu / Ayah / Papa / Mama", inputText: $viewModel.nicknameInput)
                    .kimoAccessibility(
                        label: "Kolom nama panggilan orang tua",
                        hint: "Masukkan nama panggilan yang biasa digunakan anak untuk memanggil orang tua, contoh: Papa, Mama, Ayah, Ibu",
                        traits: .isButton,
                        identifier: "identity.nicknameField",
                        sortPriority: 6
                    )
                
                Text(viewModel.errorMessageNickname)
                    .font(.customFont(size: 16, family: .primary, weight: .regular))
                    .foregroundStyle(viewModel.showErrorNickname ? ColorToken.emotionAnger.toColor() : Color.clear)
                    .padding(.top, 4)
                    .kimoTextAccessibility(
                        label: viewModel.showErrorNickname ? viewModel.errorMessageNickname : "",
                        identifier: "identity.errorMessageNickname",
                        sortPriority: 7
                    )
            }
            .padding(.horizontal, 50.getWidth())
            .padding(.vertical, 70.getHeight())
        }
    }
    
    private var submitButtonView: some View {
        HStack {
            Spacer()
            
            Button(action: {
                viewModel.submitName()
                accessibilityManager.announce("Nama panggilan berhasil disimpan.")
            }, label: {
                KimoBubbleButtonPrimary(buttonLabel: "Simpan")
            })
            .kimoButtonAccessibility(
                label: viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                "Lanjut, tidak tersedia" : "Lanjut",
                hint: viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                "Isi nama panggilan terlebih dahulu untuk melanjutkan" :
                    "Ketuk dua kali untuk menyimpan nama panggilan dan melanjutkan ke halaman identitas anak",
                identifier: "identity.continueButton"
            )
        }
    }
}

#Preview {
    IdentityView()
}
