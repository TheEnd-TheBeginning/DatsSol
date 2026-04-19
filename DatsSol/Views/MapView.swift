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
    
    @State private var plantationPosition: [Int]?
    @State private var chosenPosition: [Int]?

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
            ForEach(0..<mapManager.mapSize.x, id: \.self) { x in
                GridRow {
                    ForEach(0..<mapManager.mapSize.y, id: \.self) { y in
                        Button {
                            let actualPosition = [x + mapManager.xShift, y + mapManager.yShift]
                            let isMyPlantation = mapManager.arena!.plantations.contains(where: { $0.position == actualPosition})
                            if isMyPlantation {
                                plantationPosition = actualPosition
                            } else {
                                chosenPosition = actualPosition
                            }
                            if let plantationPosition, let chosenPosition {
                                Task {
                                    do {
                                        let commandPath = CommandPath(path: [plantationPosition, plantationPosition, chosenPosition])
                                        
                                        self.plantationPosition = nil
                                        self.chosenPosition = nil
                                        
                                        try await mapManager.sendCommandRequest(command: [commandPath],
                                                                                plantationUpgrade: .earthquake_mitigation)
                                    } catch {
                                        throw error
                                    }
                                }
                            }
                        } label: {
                            fieldView(position: [x,y])
                        }
                        .frame(width: mapManager.scaleFactor, height: mapManager.scaleFactor)
                    }
                }
            }
        }
        .scaleEffect(scale * magnifyBy)
        .gesture(magnification)
        .clipShape(Circle())
        .background(.black)
    }
    
    func fieldView(position: [Int]) -> some View {
        Group {
            let x = position.first!
            let y = position.last!
            let fieldType = getFieldType(position: [x + mapManager.xShift, y + mapManager.yShift])
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundStyle(fieldType.color)
                
                switch fieldType {
                case .construction(let progress), .terraformed(let progress):
                    Text("\(progress)")
                case .myPlantation(let isMain):
                    Text("✅")
                default:
                    Text("")
                }
            }
        }
    }
    
    func getFieldType(position: [Int]) -> FieldType {
        if let plantation = mapManager.arena?.plantations.first(where: { $0.position == position }) {
            return .myPlantation(plantation.isMain)
        }
        if let _ = mapManager.arena?.enemy.first(where: {$0.position == position}) {
            return .enemyPlantation
        }
        if mapManager.arena?.mountains.contains(position) == true {
            return .mountain
        }
        if let cell = mapManager.arena?.cells.first(where: { $0.position == position }) {
            return .terraformed(cell.terraformationProgress)
        }
        if let _ = mapManager.arena?.beavers.first(where: {$0.position == position}) {
            return .beaver
        }
        if let construction = mapManager.arena?.construction.first(where: {$0.position == position}) {
            return .construction(construction.progress)
        }
        if let currentStorm = mapManager.arena?.meteoForecasts.first(where: { $0.position == position && $0.kind == .sandstorm }) {
            return .sandstorm(true)
        }
        if let currentStorm = mapManager.arena?.meteoForecasts.first(where: { $0.nextPosition == position && $0.kind == .sandstorm }) {
            return .sandstorm(false)
        }
        if let currentStorm = mapManager.arena?.meteoForecasts.first(where: { $0.position == position && $0.kind == .earthquake }) {
            return .earthquake
        }
        return .plain
    }
}

#Preview {
    MapView()
        .environment(MapManager())
}
