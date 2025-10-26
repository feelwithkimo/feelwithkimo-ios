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

    var body: some View {
        VStack(spacing: 24) {
            KimoHeaderView {
                VStack(alignment: .center, spacing: 8) {
                    Text("Identitas Anak")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Sekarang giliran si kecil nih!")
                        .font(.title2)
                        .lineLimit(2)
                }
            }

            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                Text("Nama Anak:")
                    .font(.title2)
                    .fontWeight(.bold)

                TextField("Example: Cynthia", text: $viewModel.childName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .submitLabel(.done)
            }
            .padding(.horizontal)
            
            Spacer()

            Button(action: {
                let success = viewModel.submitChildName()
                if success {
                    dismiss()
                }
            }, label: {
                Text("Lanjut")
                    .font(.body)
                    .bold()
                    .padding(.horizontal, 26)
                    .padding(.vertical, 14)
                    .frame(maxWidth: 150)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(12)
                    .padding(.vertical, 170)
            })
            .padding(.horizontal)
            .disabled(viewModel.nicknameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

        }
        .alert("Notice", isPresented: $viewModel.showError) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}
