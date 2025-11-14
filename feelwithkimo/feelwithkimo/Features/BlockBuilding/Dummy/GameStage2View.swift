import SwiftUI

public struct GameStage2View: View {
    let onComplete: () -> Void

    public init(onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack {
            Text("Game Stage 2 Placeholder")
                .padding()
            Button("Complete Stage 2") {
                onComplete()
            }
            .padding()
        }
    }
}

#Preview {
    GameStage2View {
        print("Stage 2 completed")
    }
}
