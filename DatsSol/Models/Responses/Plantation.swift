//
//  Platation.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class Plantation: Codable {
    ///— уникальный идентификатор плантации.
    let id: String
    ///— координата плантации `[x, y]`.
    let position: [Int]
    ///— `true`, если это ЦУ (главная плантация).on
    let isMain: Bool
    ///— `true`, если плантация изолирована от связанной сети.
    let isIsolated: Bool
    ///— ход, до которого действует иммунитет после респавна/появления.
    let immunityUntilTurn: Int
    ///— текущее здоровье плантации.munityUntilTurn
    let hp: Int
}
