//
//  FieldView.swift
//  DatsSol
//
//  Created by Александра Савичева on 19.04.2026.
//

import SwiftUI

struct FieldView: View {
    @Environment(MapManager.self) private var mapManager
    
    var actualPosition: [Int]
    
    var body: some View {
        fieldView
            .frame(width: mapManager.scaleFactor, height: mapManager.scaleFactor)
            .overlay {
                RadiusView(actualPosition: actualPosition, fieldType: fieldType)
            }
    }
    
    var borderColor: Color {
        if mapManager.plantationPosition == actualPosition ||
            mapManager.chosenPosition == actualPosition {
            return .purple
        }
        return .black
    }
    
    private var fieldView: some View {
        Group {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(fieldType.color)
                    .strokeBorder(borderColor, lineWidth: 2)
                
                switch fieldType {
                case .construction(let progress):
                    Text("\(progress)")
                case .terraformed(let progress):
                    VStack(alignment: .center) {
                        Text("🌵")
                            .font(.headline)
                        Text("\(progress)")
                            .font(.footnote)
                    }
                case .myPlantation(let isMain):
                    if !isMain {
                        Text("✅")
                    }
                case .sandstorm(let isCurrentPosition):
                    Text("🌪️")
                        .font(.largeTitle)
                        .opacity(isCurrentPosition ? 1 : 0.5)
                case .beaver:
                    Text("🦫")
                        .font(.largeTitle)
                case .mountain:
                    Text("🌋")
                        .font(.largeTitle)
                default:
                    Text("")
                }
            }
        }
    }
    
    var fieldType: FieldType {
        if let plantation = mapManager.arena?.plantations.first(where: { $0.position == actualPosition }) {
            return .myPlantation(plantation.isMain)
        }
        if let _ = mapManager.arena?.enemy.first(where: { $0.position == actualPosition }) {
            return .enemyPlantation
        }
        if mapManager.arena?.mountains.contains(actualPosition) == true {
            return .mountain
        }
        if let cell = mapManager.arena?.cells.first(where: { $0.position == actualPosition }) {
            return .terraformed(cell.terraformationProgress)
        }
        if let _ = mapManager.arena?.beavers.first(where: {$0.position == actualPosition }) {
            return .beaver
        }
        if let construction = mapManager.arena?.construction.first(where: { $0.position == actualPosition }) {
            return .construction(construction.progress)
        }
        if let _ = mapManager.arena?.meteoForecasts.first(where: { $0.position == actualPosition && $0.kind == .sandstorm }) {
            return .sandstorm(true)
        }
        if let _ = mapManager.arena?.meteoForecasts.first(where: { $0.nextPosition == actualPosition && $0.kind == .sandstorm }) {
            return .sandstorm(false)
        }
        return .plain
    }
}
