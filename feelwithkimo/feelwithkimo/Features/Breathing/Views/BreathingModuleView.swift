import SwiftUI

struct BreathingModuleView: View {
    @StateObject private var viewModel = BreathingModuleViewModel()
    
    var body: some View {
        ZStack {
            Color(uiColor: ColorToken.backgroundBreathing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                BreathingPhaseComponent(viewModel: viewModel)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.startBreathingCycle()
        }
    }
}

// MARK: - Preview
struct BreathingModuleView_Previews: PreviewProvider {
    static var previews: some View {
        BreathingModuleView()
    }
}
