//
//  Disigne.swift
//  DatsSol
//
//  Created by Александра Савичева on 18.04.2026.
//

import SwiftUI

enum FieldType {
    case myPlantation(Bool)
    case enemyPlantation
    case mountain
    case terraformed(Int)
    case beaver
    case plain
    case construction(Int)
    case sandstorm(Bool)
    case earthquake
    
    var color: Color {
        switch self {
        case .myPlantation(let isMain):
            return isMain ? .green : .gray
        case .enemyPlantation:
            return .red
        case .mountain:
            return .orange
        case .terraformed(let progress):
            return .yellow.mix(with: .brown, by: Double(progress)/10)
        case .beaver:
            return .blue
        case .plain:
            return .yellow
        case .construction(let progress):
            return .yellow.mix(with: .gray, by: Double(progress)/10)
        case .sandstorm(let isCurrentPosition):
            return isCurrentPosition ? .indigo : .indigo.opacity(0.3)
        case .earthquake:
            return .teal
        }
    }
}
