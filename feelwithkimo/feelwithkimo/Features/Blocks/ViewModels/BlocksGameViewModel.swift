//
//  BlocksGameViewModel.swift
//  feelwithkimo
//
//  Created by Adeline Charlotte Augustinne on 13/11/25.
//

import SwiftUI

// MARK: - Models

enum ShapeType: String {
    case rectangle, square, arch, triangle
}

struct BlockModel: Identifiable, Equatable {
    let id = UUID()
    let type: ShapeType
    let color: Color
    var isPlaced: Bool = false
}

struct BlockPosition {
    var id: UUID
    var position: CGPoint
    var size: CGSize
}

// MARK: - Level enum

enum GameLevel: CaseIterable {
    case level1, level2
    
    var blocks: [BlockModel] {
        switch self {
        case .level1:
            return [
                BlockModel(type: .rectangle, color: Color.yellow),
                BlockModel(type: .square, color: Color.green),
                BlockModel(type: .arch, color: Color.pink)
            ]
        case .level2:
            return [
                BlockModel(type: .triangle, color: Color.yellow),
                BlockModel(type: .rectangle, color: Color.pink),
                BlockModel(type: .square, color: Color.blue)
            ]
        }
    }
}

// MARK: - PreferenceKey for capturing frames

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - ViewModel

@MainActor
final class BlocksGameViewModel: ObservableObject {
    @Published var currentLevel: GameLevel = .level1
    @Published var blocks: [BlockModel]
    @Published var outlines: [BlockModel]
    @Published var placedBlocks: Set<UUID> = []
    
    @Published var blockPositions: [UUID: BlockPosition] = [:]
    @Published var outlineFrames: [UUID: CGRect] = [:]
    
    init(level: GameLevel = .level1) {
        self.currentLevel = level
        self.blocks = level.blocks
        self.outlines = level.blocks // one outline per expected block (same sequence)
    }
    
    func markPlaced(_ id: UUID) {
        if let bi = blocks.firstIndex(where: { $0.id == id }) {
            blocks[bi].isPlaced = true
        }
        placedBlocks.insert(id)
    }
    
    func isPlaced(_ id: UUID) -> Bool { placedBlocks.contains(id) }
    
    func resetLevel(_ level: GameLevel) {
        currentLevel = level
        blocks = level.blocks
        outlines = level.blocks
        placedBlocks.removeAll()
    }
}

// MARK: - Draggable Block View

struct DraggableBlockView: View {
    let model: BlockModel
    @Binding var position: CGPoint // center in global coordinates
    let size: CGSize
    let onDragEnded: (UUID, CGPoint) -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        TupleView {
            shape(for: model.type)
                .fill(model.color)
                .frame(width: size.width, height: size.height)
                .overlay(
                    TupleView {
                        shape(for: model.type).stroke(Color.black.opacity(0.12), lineWidth: 1)
                    }
                )
                .shadow(radius: isDragging ? 8 : 2)
                .position(CGPoint(x: position.x + dragOffset.width, y: position.y + dragOffset.height))
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            isDragging = true
                            dragOffset = g.translation
                        }
                        .onEnded { g in
                            isDragging = false
                            let finalCenter = CGPoint(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                            onDragEnded(model.id, finalCenter)
                            withAnimation(.easeOut(duration: 0.25)) {
                                dragOffset = .zero
                            }
                        }
                )
                .animation(.interactiveSpring(), value: isDragging)
        }
    }
    
    private func shape(for type: ShapeType) -> any Shape {
        switch type {
        case .rectangle: RoundedRectangle(cornerRadius: 6)
        case .square: RoundedRectangle(cornerRadius: 6)
        case .arch: Capsule() // placeholder
        case .triangle: TriangleShape()
        }
    }
}

// helper Triangle
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Outline Slot View

struct OutlineSlotView: View {
    let model: BlockModel
    var body: some View {
        TupleView {
            shape(for: model.type)
                .stroke(style: StrokeStyle(lineWidth: 3, dash: [8]))
                .foregroundColor(.gray.opacity(0.6))
                .frame(width: sizeFor(model).width, height: sizeFor(model).height)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: FramePreferenceKey.self,
                                value: [model.id: geo.frame(in: .global)]
                            )
                    }
                )
        }
    }
    
    private func sizeFor(_ model: BlockModel) -> CGSize {
        switch model.type {
        case .rectangle: return CGSize(width: 220, height: 90)
        case .square: return CGSize(width: 120, height: 120)
        case .arch: return CGSize(width: 260, height: 90)
        case .triangle: return CGSize(width: 180, height: 120)
        }
    }
    
    private func shape(for type: ShapeType) -> any Shape {
        switch type {
        case .rectangle: RoundedRectangle(cornerRadius: 6)
        case .square: RoundedRectangle(cornerRadius: 6)
        case .arch: Capsule()
        case .triangle: TriangleShape()
        }
    }
}

struct BlocksGameScene: View {
    @StateObject var vm = BlocksGameViewModel()
    
    @State private var positions: [UUID: CGPoint] = [:]
    @State private var sizes: [UUID: CGSize] = [:]
    
    var body: some View {
        ZStack {
            // OUTLINES AREA (right side)
            VStack {
                ForEach(vm.outlines) { outline in
                    OutlineSlotView(model: outline)
                        .background(
                            GeometryReader { geo in
                                Color.red.preference(
                                    key: FramePreferenceKey.self,
                                    value: [outline.id: geo.frame(in: .global)]
                                )
                            }
                        )
                }
            }
            .onPreferenceChange(FramePreferenceKey.self) { frames in
                vm.outlineFrames = frames
            }
            
            // DRAGGABLE BLOCKS (bottom bar)
            VStack {
                Spacer()
                HStack(spacing: 40) {
                    ForEach(vm.blocks) { block in
                        if !vm.isPlaced(block.id) {
                            let size = sizeFor(block)
                            DraggableBlockView(
                                model: block,
                                position: Binding(
                                    get: { positions[block.id] ?? .zero },
                                    set: { positions[block.id] = $0 }
                                ),
                                size: size
                            ) { id, finalCenter in
                                handleDragEnded(id: id, center: finalCenter)
                            }
                            .onAppear {
                                positions[block.id] = initialBottomBarPosition(for: block)
                                sizes[block.id] = size
                            }
                        }
                    }
                }
                Spacer().frame(height: 40)
            }
        }
    }
    
    // MARK: - Drag Logic
    
    func handleDragEnded(id: UUID, center: CGPoint) {
        // 1. Find block index inside blocks array
        guard let blockIndex = vm.blocks.firstIndex(where: { $0.id == id }) else {
            snapBack(id)
            return
        }
        
        // 2. Get matching outline model & its frame
        let outlineModel = vm.outlines[blockIndex]
        
        guard let outlineFrame = vm.outlineFrames[outlineModel.id] else {
            snapBack(id)
            return
        }
        
        let outlineCenter = CGPoint(x: outlineFrame.midX, y: outlineFrame.midY)
        
        // 3. Distance check
        let distance = hypot(center.x - outlineCenter.x,
                             center.y - outlineCenter.y)
        
        if distance < 120 {
            vm.markPlaced(id)
            withAnimation {
                positions[id] = outlineCenter
            }
        } else {
            snapBack(id)
        }
    }
    
    func snapBack(_ id: UUID) {
        withAnimation {
            positions[id] = initialBottomBarPosition(for: vm.blocks.first { $0.id == id }!)
        }
    }
    
    // MARK: - Helpers
    
    func initialBottomBarPosition(for block: BlockModel) -> CGPoint {
        // return a precise pixel coordinate inside your bottom bar
        CGPoint(x: 200, y: UIScreen.main.bounds.height - 120)
    }
    
    func sizeFor(_ block: BlockModel) -> CGSize {
        switch block.type {
        case .rectangle: return CGSize(width: 220, height: 90)
        case .square: return CGSize(width: 120, height: 120)
        case .arch: return CGSize(width: 260, height: 90)
        case .triangle: return CGSize(width: 180, height: 120)
        }
    }
}

#Preview {
    BlocksGameScene()
}
