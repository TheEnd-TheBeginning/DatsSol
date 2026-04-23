//
//  Disigne.swift
//  DatsSol
//
//  Created by Александра Савичева on 18.04.2026.
//

import SwiftUI

enum FieldType: Equatable {
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
            return .red.opacity(0.4)
        case .terraformed(let progress):
            return .forestGreen.opacity(Double(progress)/100)
        case .beaver:
            return .blue.opacity(0.3)
        case .plain:
            return .clear
        case .construction(let progress):
            return .yellow.mix(with: .gray, by: Double(progress)/10)
        case .sandstorm(let isCurrentPosition):
            return isCurrentPosition ? .indigo.opacity(0.5) : .indigo.opacity(0.2)
        case .earthquake:
            return .pink
        }
    }
}
