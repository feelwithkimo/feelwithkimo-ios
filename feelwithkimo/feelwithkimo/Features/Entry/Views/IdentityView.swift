//
//  IdentityView.swift
//  
//
//  Created by Richard Sugiharto on 20/10/25.
//

import SwiftUI

struct IdentityView: View {
    @AppStorage("identity") var identity = ""
    @StateObject var viewModel: IdentityViewModel = IdentityViewModel()

    var body: some View {
        if identity == "" {
            VStack(spacing: 24) {
                KimoHeaderView {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Identitas Orang Tua")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Yuk, isi sedikit data supaya Kimo bisa mengenal keluarga kecilmu!")
                            .font(.title2)
                            .lineLimit(2)
                    }
                }
                
                Spacer()

                VStack(alignment: .center, spacing: 8) {
                    Text("Nama panggilan anak terhadap orang tua:")
                        .font(.title2)
                        .fontWeight(.bold)

                    TextField("Example: Papa", text: $viewModel.nicknameInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 0.5 * UIScreen.main.bounds.width)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.submitNickname()
                        }
                }
                .padding(.horizontal)
                
                Spacer()

                Button(action: {
                    viewModel.submitNickname()
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
            .navigationDestination(isPresented: $viewModel.navigateToChild) {
                ChildIdentityView(viewModel: viewModel)
            }
            .onAppear {
                if !viewModel.parentNickname.isEmpty {
                    viewModel.nicknameInput = viewModel.parentNickname
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
