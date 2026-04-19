//
//  Beaver.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class Beaver: Codable {
    /// — идентификатор цели.
    let id: String
    /// — координата `[x, y]`.
    let position: [Int]
    /// — текущее здоровье.
    let hp: Int
}
