import SwiftUI

struct BreathingModuleView: View {
    let onCompletion: () -> Void
    
    @StateObject private var viewModel = BreathingModuleViewModel()
    @State private var showCompletionPage = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(uiColor: ColorToken.backgroundBreathing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                BreathingPhaseComponent(viewModel: viewModel)
                
                Spacer()
            }
            
            /// Show completion page overlay when breathing is finished
            if showCompletionPage {
                CompletionPageView(
                    title: "Latihan Selesai!!!",
                    primaryButtonLabel: "Coba lagi",
                    secondaryButtonLabel: "Lanjutkan",
                    onPrimaryAction: {
                        /// Reset and restart breathing exercise
                        showCompletionPage = false
                        viewModel.resetBreathingCycle()
                        viewModel.startBreathingCycle()
                    },
                    onSecondaryAction: {
                        /// Continue to next story scene
                        print("DEBUG: Lanjutkan button tapped")
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onCompletion()
                        }
                    }
                )
            }
        }
        .onAppear {
            viewModel.startBreathingCycle()
        }
        .onChange(of: viewModel.hasCompleted) { completed in
            if completed {
                showCompletionPage = true
            }
        }
    }
}

// MARK: - Preview
struct BreathingModuleView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingModuleView(onCompletion: {
            print("Breathing exercise completed")
        })
    }
}
