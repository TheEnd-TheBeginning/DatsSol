//
//  RadiusView.swift
//  DatsSol
//
//  Created by Александра Савичева on 21.04.2026.
//

import SwiftUI

struct RadiusView: View {
    var field: FieldManager
    
    private var color: Color {
        switch field.fieldType {
        case .myPlantation(_):
            return .green
        case .sandstorm(let isCurrentPosition) where isCurrentPosition:
            return .red
        default:
            return .clear
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
        .fill(.clear)
        .strokeBorder(color, lineWidth: 2)
        .frame(width: field.actionArea, height: field.actionArea)
        .opacity(field.actionArea == 0 ? 0 : 1)
    }
}
