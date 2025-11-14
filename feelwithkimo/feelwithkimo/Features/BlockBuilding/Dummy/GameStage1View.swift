import SwiftUI

public struct GameStage1View: View {
    let onComplete: () -> Void

    public init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack {
            Text("Game Stage 1 Placeholder")
                .padding()
            Button("Complete Stage 1") {
                onComplete()
            }
            .padding()
        }
    }
}

#Preview {
    GameStage1View {
        print("Stage 1 completed")
    }
}
