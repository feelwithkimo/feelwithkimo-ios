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
        if viewModel.identity == "" {
            VStack(spacing: 24) {
                KimoHeaderView {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Identitas Orang Tua")
                            .font(.app(.largeTitle, family: .primary))
                            .fontWeight(.bold)
                            .kimoTextAccessibility(
                                label: "Identitas Orang Tua",
                                identifier: "identity.parentTitle",
                                sortPriority: 1
                            )

                        Text("Yuk, isi sedikit data supaya Kimo bisa mengenal keluarga kecilmu!")
                            .font(.app(.title2, family: .primary))
                            .lineLimit(2)
                            .kimoTextAccessibility(
                                label: "Yuk, isi sedikit data supaya Kimo bisa mengenal keluarga kecilmu!",
                                identifier: "identity.parentDescription",
                                sortPriority: 2
                            )
                    }
                }
                
                Spacer()

                VStack(alignment: .center, spacing: 8) {
                    Text("Nama panggilan anak terhadap orang tua:")
                        .font(.app(.title2, family: .primary))
                        .fontWeight(.bold)
                        .kimoTextAccessibility(
                            label: "Nama panggilan anak terhadap orang tua:",
                            identifier: "identity.nicknameLabel",
                            sortPriority: 3
                        )
                    
                    KimoTextField(placeholder: "Example: Papa", inputText: $viewModel.nicknameInput)
                        .kimoAccessibility(
                            label: "Kolom nama panggilan orang tua",
                            hint: "Masukkan nama panggilan yang biasa digunakan anak untuk memanggil orang tua, contoh: Papa, Mama, Ayah, Ibu",
                            traits: .isButton,
                            identifier: "identity.nicknameField",
                            sortPriority: 4
                        )
                }
                .padding(.horizontal)
                
                Spacer()

                Button(action: {
                    viewModel.submitNickname()
                    accessibilityManager.announce("Nama panggilan berhasil disimpan. Melanjutkan ke halaman identitas anak.")
                }, label: {
                    Text("Lanjut")
                        .font(.app(.body, family: .primary))
                        .bold()
                        .padding(.horizontal, 26)
                        .padding(.vertical, 14)
                        .frame(maxWidth: 150)
                        .background(ColorToken.backgroundMain.toColor())
                        .foregroundStyle(ColorToken.textPrimary.toColor())
                        .cornerRadius(12)
                        .padding(.vertical, 170)
                })
                .padding(.horizontal)
                .disabled(viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .kimoButtonAccessibility(
                    label: viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                        "Lanjut, tidak tersedia" : "Lanjut",
                    hint: viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                        "Isi nama panggilan terlebih dahulu untuk melanjutkan" : 
                        "Ketuk dua kali untuk menyimpan nama panggilan dan melanjutkan ke halaman identitas anak",
                    identifier: "identity.continueButton"
                )
            }
            .navigationDestination(isPresented: $viewModel.navigateToChild) {
                ChildIdentityView(viewModel: viewModel)
            }
            .onAppear {
                if !viewModel.parentNickname.isEmpty {
                    viewModel.nicknameInput = viewModel.parentNickname
                }
                
                // Announce screen when it appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    accessibilityManager.announceScreenChange("Halaman identitas orang tua. Silakan isi nama panggilan yang digunakan anak untuk memanggil orang tua.")
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
