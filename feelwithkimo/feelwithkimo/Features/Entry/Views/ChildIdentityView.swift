//
//  ChildIdentityView.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct ChildIdentityView: View {
    @AppStorage("identity") var identity = ""
    @ObservedObject var viewModel: IdentityViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var accessibilityManager = AccessibilityManager.shared

    var body: some View {
        VStack(spacing: 24) {
            KimoHeaderView {
                VStack(alignment: .center, spacing: 8) {
                    Text("Identitas Anak")
                        .font(.app(.largeTitle, family: .primary))
                        .fontWeight(.bold)
                        .kimoTextAccessibility(
                            label: "Identitas Anak",
                            identifier: "childIdentity.title",
                            sortPriority: 1
                        )

                    Text("Sekarang giliran si kecil nih!")
                        .font(.app(.title2, family: .primary))
                        .lineLimit(2)
                        .kimoTextAccessibility(
                            label: "Sekarang giliran si kecil nih!",
                            identifier: "childIdentity.description",
                            sortPriority: 2
                        )
                }
            }

            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                Text("Nama Anak:")
                    .font(.app(.title2, family: .primary))
                    .fontWeight(.bold)
                    .kimoTextAccessibility(
                        label: "Nama Anak:",
                        identifier: "childIdentity.nameLabel",
                        sortPriority: 3
                    )

                TextField("Example: Cynthia", text: $viewModel.childName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .submitLabel(.done)
                    .kimoAccessibility(
                        label: "Kolom nama anak",
                        hint: "Masukkan nama anak, contoh: Cynthia. Ketuk dua kali untuk mengedit",
                        traits: .isButton,
                        identifier: "childIdentity.nameField",
                        sortPriority: 4
                    )
            }
            .padding(.horizontal)
            
            Spacer()

            Button(action: {
                let success = viewModel.submitChildName()
                if success {
                    accessibilityManager.announce("Identitas berhasil disimpan. Menuju halaman utama aplikasi.")
                    dismiss()
                }
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
            .disabled(viewModel.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .kimoButtonAccessibility(
                label: viewModel.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                    "Lanjut, tidak tersedia" : "Lanjut",
                hint: viewModel.childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                    "Isi nama anak terlebih dahulu untuk melanjutkan" : 
                    "Ketuk dua kali untuk menyimpan nama anak dan menuju halaman utama",
                identifier: "childIdentity.finishButton"
            )

        }
        .alert("Notice", isPresented: $viewModel.showError) {
            Button("Close", role: .cancel) { }
                .kimoButtonAccessibility(
                    label: "Tutup",
                    hint: "Ketuk dua kali untuk menutup peringatan",
                    identifier: "childIdentity.closeAlert"
                )
        } message: {
            Text(viewModel.alertMessage)
                .kimoTextAccessibility(
                    label: viewModel.alertMessage,
                    identifier: "childIdentity.alertMessage"
                )
        }
        .onAppear {
            // Announce screen when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                accessibilityManager.announceScreenChange("Halaman identitas anak. Silakan masukkan nama anak untuk melengkapi pengaturan awal.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
