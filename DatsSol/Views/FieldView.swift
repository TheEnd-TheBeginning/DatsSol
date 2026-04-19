//
//  FieldView.swift
//  DatsSol
//
//  Created by Александра Савичева on 19.04.2026.
//

import SwiftUI

struct FieldView: View {
    var actualPosition: [Int]
    
    @Environment(MapManager.self) private var mapManager
 
    init(position: [Int]) {
        self.actualPosition = position
    }
    
    var body: some View {
        Button {
//            let isMyPlantation = mapManager.arena!.plantations.contains(where: { $0.position == actualPosition})
//            if isMyPlantation {
//                mapManager.plantationPosition = actualPosition
//            } else {
//                mapManager.chosenPosition = actualPosition
//            }
        } label: {
            fieldView
                .border(borderColor)
        }
        .frame(width: mapManager.scaleFactor, height: mapManager.scaleFactor)
    }
    
    var borderColor: Color {
        if mapManager.plantationPosition == actualPosition ||
            mapManager.chosenPosition == actualPosition {
            return .purple
        }
        return .clear
    }
    
    private var fieldView: some View {
        Group {
            let fieldType = getFieldType(position: actualPosition)
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundStyle(fieldType.color)
                
                switch fieldType {
                case .construction(let progress), .terraformed(let progress):
                    Text("\(progress)")
                case .myPlantation(let isMain):
                    if !isMain {
                        Text("✅")
                    }
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
        if let nextStorm = mapManager.arena?.meteoForecasts.first(where: { $0.nextPosition == position && $0.kind == .sandstorm }) {
            return .sandstorm(false)
        }
        if let earthquake = mapManager.arena?.meteoForecasts.first(where: { $0.position == position && $0.kind == .earthquake }) {
            return .earthquake
        }
        return .plain
    }
}
