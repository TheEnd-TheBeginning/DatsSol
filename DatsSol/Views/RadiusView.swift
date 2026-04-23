//
//  RadiusView.swift
//  DatsSol
//
//  Created by Александра Савичева on 21.04.2026.
//

import SwiftUI

struct RadiusView: View {
    @Environment(MapManager.self) private var mapManager
    var actualPosition: [Int]
    var fieldType: FieldType
    
    private var color: Color {
        switch fieldType {
        case .myPlantation(_):
            return .green
        case .sandstorm(let isCurrentPosition) where isCurrentPosition:
            return .red
        default:
            return .clear
        }
    }
    
    private var radius: CGFloat {
        switch fieldType {
        case .myPlantation(_):
            let actionRange = mapManager.arena?.actionRange ?? 0
            if let _ = mapManager.arena?.plantations.first(where: { $0.position == actualPosition }) {
                return CGFloat(actionRange) * mapManager.scaleFactor
            }
            return 0
            
        case .sandstorm(let isCurrentPosition) where isCurrentPosition:
            return mapManager.stormRadius(position: actualPosition)
            
        default:
            return 0
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
        .fill(.clear)
        .strokeBorder(color, lineWidth: 2)
        .frame(width: 2 * radius + mapManager.scaleFactor, height: 2 * radius + 4 + mapManager.scaleFactor)
        .opacity(radius == 0 ? 0 : 1)
    }
}
