//
//  Cell.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class Cell: Codable {
    /// — координата клетки `[x, y]`.
    let position: [Int]
    /// — текущий прогресс терраформации клетки.
    let terraformationProgress: Int
    /// — через сколько ходов начнётся деградация, если клетка потеряет поддержку
    let turnsUntilDegradation: Int
}
