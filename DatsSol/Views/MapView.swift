//
//  MapView.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import SwiftUI

struct MapView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(MapManager.self) private var mapManager
    
    @Binding var needTeleport: Bool
    @Binding var scale: CGFloat
    
    @GestureState private var magnifyBy: CGFloat = 1.0

    var gridRows: [GridItem] {
        return Array<GridItem>(
            repeating: GridItem(.fixed(FieldManager.fieldScale), spacing: 2),
            count: MapManager.arenaRadius * 2
        )
    }
    
    var maxScale: CGFloat {
        return horizontalSizeClass == .compact ? 1 : 3
    }
    var minScale: CGFloat {
        return horizontalSizeClass == .compact ? 0.19 : 0.41
    }
    var arenaD: Int {
        return MapManager.arenaRadius * 2
    }
    
    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, _ in
                guard value.magnification < maxScale,
                      value.magnification > minScale else { return }
                gestureState = value.magnification
            }
            .onEnded { value in
                let currScale = scale * value.magnification
                guard currScale < maxScale else {
                    scale = maxScale
                    return
                }
                guard currScale > minScale else {
                    scale = minScale
                    return
                }
            
                scale = currScale
            }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                mapGrid
                    .onChange(of: needTeleport) {
                        if needTeleport {
                            teleportToMain(proxy: proxy)
                        }
                    }
                    .background(
                        Image(ImageResource.marsBackground)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .scaleEffect(scale)
                    .gesture(magnification)
                    .frame(maxWidth: CGFloat(arenaD) * FieldManager.fieldScale * scale,
                           maxHeight: CGFloat(arenaD) * FieldManager.fieldScale * scale)
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.horizontal,.vertical])
        }
        .clipShape(Circle())
    }
    
    private var mapGrid: some View {
        LazyHGrid(rows: gridRows, spacing: 2) {
            ForEach(mapManager.mapSnapshot) { field in
                FieldView(field: field)
                    .id(field.mapPosition)
            }
        }
    }
    
    private func teleportToMain(proxy: ScrollViewProxy) {
        withAnimation {
            let x = MapManager.arenaRadius
            let y = MapManager.arenaRadius
            proxy.scrollTo([x, y], anchor: .center)
        }
        needTeleport = false
    }
}

#Preview {
    @Previewable @State var needTeleport: Bool = false
    @Previewable @State var scale: CGFloat = 1
    MapView(needTeleport: $needTeleport, scale: $scale)
}
