//
//  PageCurlTransition.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/11/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

// MARK: - 1. The Transition Modifier
struct PageCurlTransitionModifier: ViewModifier {
    let isForward: Bool
    let reduceMotion: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(
                reduceMotion ? .opacity : .asymmetric(
                    // INSERTION: From Curled (0) to Flat (1)
                    insertion: AnyTransition.modifier(
                        active: PageCurlModifier(progress: 0, isForward: isForward),
                        identity: PageCurlModifier(progress: 1, isForward: isForward)
                    ),
                    // REMOVAL: From Flat (1) to Curled (0)
                    removal: AnyTransition.modifier(
                        active: PageCurlModifier(progress: 0, isForward: isForward),
                        identity: PageCurlModifier(progress: 1, isForward: isForward)
                    )
                )
            )
    }
}

// MARK: - 2. The Geometry Modifier (Animatable)
struct PageCurlModifier: ViewModifier, Animatable {
    var progress: Double
    let isForward: Bool
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            // 1. Rotation: Simulates the page bending
            .rotation3DEffect(
                .degrees(calcRotation()),
                axis: (x: 0, y: 1, z: 0),
                anchor: isForward ? .leading : .trailing, // Pivot point
                perspective: 0.5
            )
            // 2. Offset: Moves the page slightly as it curls
            .offset(x: calcOffset())
            // 3. Opacity: Fades out when fully curled to prevent glitching
            .opacity(progress < 0.2 ? progress * 5 : 1)
            // 4. ZIndex: Ensures the curling page stays on top
            .zIndex(progress)
    }
    
    // Helper: Calculate Rotation Angle
    private func calcRotation() -> Double {
        let targetAngle: Double = isForward ? -90 : 90
        return (1 - progress) * targetAngle
    }
    
    // Helper: Calculate X Offset
    private func calcOffset() -> CGFloat {
        let width = UIScreen.main.bounds.width
        // When progress is 1 (Flat), offset is 0.
        // When progress is 0 (Curled), offset moves entirely off screen.
        return isForward ? (progress - 1) * width : (1 - progress) * width
    }
}

// MARK: - 3. Extensions
extension AnyTransition {
    static func pageCurl(isForward: Bool) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: PageCurlModifier(progress: 0, isForward: isForward),
                identity: PageCurlModifier(progress: 1, isForward: isForward)
            ),
            removal: .modifier(
                active: PageCurlModifier(progress: 0, isForward: isForward),
                identity: PageCurlModifier(progress: 1, isForward: isForward)
            )
        )
    }
}

extension View {
    func pageCurlTransition(isForward: Bool, reduceMotion: Bool) -> some View {
        self.modifier(PageCurlTransitionModifier(isForward: isForward, reduceMotion: reduceMotion))
    }
}

// MARK: - Preview
#Preview {
    PageCurlTransitionPreview()
}

struct PageCurlTransitionPreview: View {
    @State private var currentPage = 0
    @State private var isForward = true
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    let scenes = ["Scene 1", "Scene 2", "Scene 3", "Scene 4", "Scene 5"]
    let colors: [Color] = [.blue, .red, .green, .orange, .purple]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Content
            ZStack {
                colors[currentPage % colors.count]
                Text(scenes[currentPage])
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }
            // This ID forces the view to redraw/transition when page changes
            .id(currentPage)
            .pageCurlTransition(isForward: isForward, reduceMotion: reduceMotion)
            
            // Controls
            VStack {
                Spacer()
                HStack(spacing: 60) {
                    Button("Previous") {
                        if currentPage > 0 {
                            isForward = false
                            withAnimation(.easeInOut(duration: 0.8)) {
                                currentPage -= 1
                            }
                        }
                    }
                    .disabled(currentPage == 0)
                    .buttonStyle(.borderedProminent)
                    
                    Button("Next") {
                        if currentPage < scenes.count - 1 {
                            isForward = true
                            withAnimation(.easeInOut(duration: 0.8)) {
                                currentPage += 1
                            }
                        }
                    }
                    .disabled(currentPage == scenes.count - 1)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 50)
            }
        }
    }
}
