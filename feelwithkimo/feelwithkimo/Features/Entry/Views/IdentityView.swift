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
        if viewModel.identity == "" || viewModel.parentNickname == "" {
            VStack {
                KimoHeaderView {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Kenalan Yuk!")
                            .font(.app(.largeTitle, family: .primary))
                            .fontWeight(.bold)
                            .kimoTextAccessibility(
                                label: "Isi identitas",
                                identifier: "identity.parentTitle",
                                sortPriority: 1
                            )

                        Text("Isi dulu ya, supaya Kimo bisa memanggil si kecil dengan benar.")
                            .font(.app(.title2, family: .primary))
                            .fontWeight(.regular)
                            .lineLimit(2)
                            .kimoTextAccessibility(
                                label: "Isi dulu ya, supaya Kimo bisa memanggil si kecil dengan benar.",
                                identifier: "identity.parentDescription",
                                sortPriority: 2
                            )
                    }
                }
                
                HStack(spacing: 120.getWidth()) {
                    Image("KimoDance")
                        .resizable()
                        .scaledToFit()
                        .kimoImageAccessibility(
                            label: "Kimo, karakter utama aplikasi",
                            isDecorative: false,
                            identifier: "entry.kimoCharacter"
                        )
                    
                    VStack(alignment: .leading) {
                        Text("Nama Si Kecil:")
//                            .font(.app(.title2 , family: .primary))
                            .font(.title2)
                            .fontWeight(.bold)
                            .kimoTextAccessibility(
                                label: "Nama si kecil",
                                identifier: "identity.nicknameChildLabel",
                                sortPriority: 3
                            )
                        
                        KimoTextField(placeholder: "Misal: Lala", inputText: $viewModel.childNicknameInput)
                            .kimoAccessibility(
                                label: "Kolom nama anak",
                                hint: "Masukkan nama anak",
                                traits: .isButton,
                                identifier: "identity.nicknameChildField",
                                sortPriority: 4
                            )
                        
                        Text(viewModel.errorMessageChild)
                            .font(.app(.callout, family: .primary))
                            .foregroundColor(viewModel.showErrorChild ? ColorToken.emotionAnger.toColor() : Color.clear)
                            .padding(.top, 7)
                            .kimoTextAccessibility(
                                label: viewModel.showErrorChild ? viewModel.errorMessageChild : "",
                                identifier: "identity.errorMessageChild",
                                sortPriority: 5
                            )
                        
                        Text("Nama Panggilan untuk Orang Tua:")
                            .font(.app(.title2, family: .primary))
                            .fontWeight(.bold)
                            .kimoTextAccessibility(
                                label: "Nama Panggilan untuk Orang Tua:",
                                identifier: "identity.nicknameLabel",
                                sortPriority: 6
                            )
                            .padding(.top, 12.getHeight())
                        
                        KimoTextField(placeholder: "Misal: Ibu / Ayah / Papa / Mama", inputText: $viewModel.nicknameInput)
                            .kimoAccessibility(
                                label: "Kolom nama panggilan orang tua",
                                hint: "Masukkan nama panggilan yang biasa digunakan anak untuk memanggil orang tua, contoh: Papa, Mama, Ayah, Ibu",
                                traits: .isButton,
                                identifier: "identity.nicknameField",
                                sortPriority: 7
                            )
                        
                        Text(viewModel.errorMessageNickname)
                            .font(.app(.callout, family: .primary))
                            .foregroundColor(viewModel.showErrorNickname ? ColorToken.emotionAnger.toColor() : Color.clear)
                            .padding(.top, 7)
                            .kimoTextAccessibility(
                                label: viewModel.showErrorNickname ? viewModel.errorMessageNickname : "",
                                identifier: "identity.errorMessageNickname",
                                sortPriority: 8
                            )
                    }
                }
                .padding(.horizontal, 82.getWidth())
                .padding(.top, 91.getHeight())
                .padding(.bottom, 49.getHeight())
                
                // Button
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
                .padding(.horizontal, 82)
                
                Spacer()
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

#Preview {
    IdentityView()
}
