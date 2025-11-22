//
//  PageCurlTransition.swift
//  feelwithkimo
//
//  Created by Ferdinand Lunardy on 21/11/25.
//

import SwiftUI

// MARK: - 1. The Transition Modifier
struct PageCurlTransitionModifier: ViewModifier {
    let isForward: Bool
    let reduceMotion: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(
                reduceMotion ? .opacity : .asymmetric(
                    insertion: AnyTransition.modifier(
                        active: PageCurlModifier(progress: 0, isForward: isForward),
                        identity: PageCurlModifier(progress: 1, isForward: isForward)
                    ),
                    
                    removal: AnyTransition.modifier(
                        active: PageCurlModifier(progress: 0, isForward: isForward),
                        identity: PageCurlModifier(progress: 1, isForward: isForward)
                    )
                )
            )
    }
}

// MARK: - 2. The Geometry Effect (The "Peel" Logic)
struct PageCurlModifier: ViewModifier, Animatable {
    var progress: Double
    let isForward: Bool
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            let size = geo.size
            
            ZStack(alignment: isForward ? .trailing : .leading) {
                // THE PAGE CONTENT
                content
                    .frame(width: size.width, height: size.height)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                
                // THE SHADOW OVERLAY
                LinearGradient(
                    colors: [.black.opacity(0.5), .clear],
                    startPoint: isForward ? .trailing : .leading,
                    endPoint: isForward ? .leading : .trailing
                )
                .opacity(1 - progress)
                .allowsHitTesting(false)
            }
            // 3D ROTATION LOGIC
            .rotation3DEffect(
                .degrees(calcRotation()),
                axis: (x: 0, y: 1, z: 0),
                anchor: isForward ? .trailing : .leading,
                perspective: 0.8
            )
        }
        .zIndex(progress < 1 ? 100 : 0)
        .ignoresSafeArea(.all)
    }
    
    private func calcRotation() -> Double {
        let targetAngle: Double = isForward ? 90 : -90
        return (1 - progress) * targetAngle
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
    PageCurlPreview()
}

struct PageCurlPreview: View {
    @State private var currentPage = 0
    @State private var isForward = true
    
    let colors: [Color] = [.blue, .red, .orange, .purple, .green]
    let scenes = ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // PAGE CONTENT
            ZStack {
                colors[currentPage % colors.count]
                
                VStack(spacing: 20) {
                    Text(scenes[currentPage])
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .ignoresSafeArea()
            .id(currentPage)
            .pageCurlTransition(isForward: isForward, reduceMotion: false)
            
            // CONTROLS
            VStack {
                Spacer()
                HStack(spacing: 60) {
                    Button {
                        guard currentPage > 0 else { return }
                        isForward = false
                        withAnimation(.easeInOut(duration: 0.7)) {
                            currentPage -= 1
                        }
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                    }
                    .disabled(currentPage == 0)
                    
                    Button {
                        guard currentPage < scenes.count - 1 else { return }
                        isForward = true
                        withAnimation(.easeInOut(duration: 0.7)) {
                            currentPage += 1
                        }
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                    }
                    .disabled(currentPage == scenes.count - 1)
                }
                .padding(.bottom, 50)
            }
        }
    }
}
