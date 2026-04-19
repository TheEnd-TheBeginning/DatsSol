//
//  MapView.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import SwiftUI

struct MapView: View {
    @Environment(MapManager.self) private var mapManager
    
    @State private var scale: CGFloat = 1.0
    @GestureState private var magnifyBy = 1.0

    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, state, _ in
                state = value.magnification
            }
            .onEnded { value in
                scale *= value.magnification
            }
    }
    
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 10)
    }
    private var gridRows: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 10)
    }
    
    var body: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            ForEach(0..<mapManager.mapSize.x, id: \.self) { y in
                GridRow {
                    ForEach(0..<mapManager.mapSize.y, id: \.self) { x in
                        let actualPosition = [x + mapManager.xShift, y + mapManager.yShift]
                        FieldView(position: actualPosition)
                    }
                }
            }
        }
        .scaleEffect(scale * magnifyBy)
        .gesture(magnification)
        .clipShape(Circle())
        .background(.black)
    }    
}

#Preview {
    MapView()
        .environment(MapManager())
}
