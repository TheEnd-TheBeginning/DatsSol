//
//  FieldView.swift
//  DatsSol
//
//  Created by Александра Савичева on 19.04.2026.
//

import SwiftUI

struct FieldView: View {
    @Environment(MapManager.self) private var mapManager
    var field: FieldManager
    
    var body: some View {
        fieldView
            .frame(width: FieldManager.fieldScale, height: FieldManager.fieldScale)
            .overlay {
                RadiusView(field: field)
            }
    }
    
    var borderColor: Color {
        if mapManager.plantationPosition == field.actualPosition ||
            mapManager.chosenPosition == field.actualPosition {
            return .purple
        }
        return .black
    }
    
    private var fieldView: some View {
        Group {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(field.fieldType.color)
                    .strokeBorder(borderColor, lineWidth: 2)
                
                switch field.fieldType {
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
}
