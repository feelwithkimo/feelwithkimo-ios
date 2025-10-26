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
            .padding(.top, 175)
            
            KimoButton(textLabel: "Selesai")
                .onTapGesture {
                    if viewModel.submitChildName() {
                        dismiss()
                    }
                }
                .padding(.top, 168)

        }
        .alert("Notice", isPresented: $viewModel.showError) {
            Button("Close", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}
