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
                titleView
                
                contentView
                
                submitButtonView
                
                Spacer()
            }
            .background(ColorToken.emotionSadness.toColor())
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
    
    private var titleView: some View {
        Text("Kenalan Yuk!")
            .font(Font(
                UIFont.appFont(
                    size: 104.getAdaptiveWidth(),
                    family: .primary,
                    weight: .bold
                )
            ))
            .foregroundStyle(ColorToken.backgroundSecondary.toColor())
            .kimoTextAccessibility(
                label: "Isi identitas",
                identifier: "identity.parentTitle",
                sortPriority: 1
            )
    }
    
    private var contentView: some View {
        HStack(spacing: 120.getWidth()) {
            kimoMascotView
            
            textFieldView
        }
        .padding(.horizontal, 82.getWidth())
        .padding(.top, 91.getHeight())
        .padding(.bottom, 49.getHeight())
    }
    
    private var ellipseView: some View {
        ZStack {
            Ellipse()
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
        VStack(alignment: .leading) {
            Text("Nama Si Kecil:")
                .font(.app(.title2, family: .primary))
                .fontWeight(.bold)
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
                .font(.app(.callout, family: .primary))
                .foregroundColor(viewModel.showErrorChild ? ColorToken.emotionAnger.toColor() : Color.clear)
                .padding(.top, 7)
                .kimoTextAccessibility(
                    label: viewModel.showErrorChild ? viewModel.errorMessageChild : "",
                    identifier: "identity.errorMessageChild",
                    sortPriority: 4
                )
            
            Text("Nama Panggilan untuk Orang Tua:")
                .font(.app(.title2, family: .primary))
                .fontWeight(.bold)
                .kimoTextAccessibility(
                    label: "Nama Panggilan untuk Orang Tua:",
                    identifier: "identity.nicknameLabel",
                    sortPriority: 5
                )
                .padding(.top, 12.getHeight())
            
            KimoTextField(placeholder: "Misal: Ibu / Ayah / Papa / Mama", inputText: $viewModel.nicknameInput)
                .kimoAccessibility(
                    label: "Kolom nama panggilan orang tua",
                    hint: "Masukkan nama panggilan yang biasa digunakan anak untuk memanggil orang tua, contoh: Papa, Mama, Ayah, Ibu",
                    traits: .isButton,
                    identifier: "identity.nicknameField",
                    sortPriority: 6
                )
            
            Text(viewModel.errorMessageNickname)
                .font(.app(.callout, family: .primary))
                .foregroundColor(viewModel.showErrorNickname ? ColorToken.emotionAnger.toColor() : Color.clear)
                .padding(.top, 7)
                .kimoTextAccessibility(
                    label: viewModel.showErrorNickname ? viewModel.errorMessageNickname : "",
                    identifier: "identity.errorMessageNickname",
                    sortPriority: 7
                )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 45)
        .background(
            Image("Iden-Rounded-Rect")
                .resizable()
                .scaledToFill()
        )
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
        .padding(.horizontal, 82)
    }
}

#Preview {
    IdentityView()
}
