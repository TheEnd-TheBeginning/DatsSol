//
//  FieldManager.swift
//  DatsSol
//
//  Created by Александра Савичева on 25.04.2026.
//

import Foundation

@Observable
class FieldManager: Identifiable {
    static let fieldScale: CGFloat = 50
    
    let mapPosition: [Int]
    private(set) var actualPosition: [Int]
    private(set) var fieldType: FieldType = .plain
    private(set) var actionArea: CGFloat = 0
    
    init(mapPosition: [Int]) {
        self.mapPosition = mapPosition
        self.actualPosition = mapPosition
    }
    
    func setField(actualPosition: [Int], fieldType: FieldType = .plain, radius: CGFloat = 0) {
        self.actualPosition = actualPosition
        self.fieldType = fieldType
        self.actionArea = radius != 0 ? radius * 2 + FieldManager.fieldScale : 0
    }
}
