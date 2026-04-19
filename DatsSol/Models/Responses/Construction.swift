//
//  Construction.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class Construction: Codable {
    /// — координата стройки `[x, y]`.
    let position: [Int]
    /// — текущий прогресс строительства.
    let progress: Int
}
