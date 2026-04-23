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
    
    var maxScale: CGFloat {
        return horizontalSizeClass == .compact ? 1 : 3
    }
    var minScale: CGFloat {
        return horizontalSizeClass == .compact ? 0.19 : 0.41
    }
    var arenaD: Int {
        return mapManager.arenaRadius * 2
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
                    .frame(maxWidth: CGFloat(arenaD) * mapManager.scaleFactor * scale,
                           maxHeight: CGFloat(arenaD) * mapManager.scaleFactor * scale)
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.horizontal,.vertical])
        }
        .clipShape(Circle())
    }
    
    private var mapGrid: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            ForEach(0..<arenaD, id: \.self) { y in
                GridRow {
                    ForEach(0..<arenaD, id: \.self) { x in
                        let actualPosition = [x + mapManager.xShift, y + mapManager.yShift]
                        FieldView(actualPosition: actualPosition)
                            .animation(.default, value: actualPosition)
                            .id([x,y])
                    }
                }
            }
        }
    }
    
    private func teleportToMain(proxy: ScrollViewProxy) {
        withAnimation {
            let x = mapManager.arenaRadius
            let y = mapManager.arenaRadius
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
