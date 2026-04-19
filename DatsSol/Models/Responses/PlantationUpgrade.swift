//
//  plantationUpgrade.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class PlantationUpgrade: Codable {
    /// — сколько очков апгрейда доступно сейчас.
    let points: Int
    /// — раз в сколько ходов начисляется новое очко апгрейда.
    let intervalTurns: Int
    /// — через сколько ходов придёт следующее очко.
    let turnsUntilPoints: Int
    /// — максимальный запас очков апгрейда.
    let maxPoints: Int
    /// — список всех доступных веток улучшений.
    let tiers: [Tier]
}

enum TierName: String, Codable, CaseIterable {
    /// — сила ремонта и строительства.
    case repair_power = "repair_power"
    /// — максимальное здоровье плантаций.
    case max_hp = "max_hp"
    /// — лимит плантаций.
    case settlement_limit = "settlement_limit"
    /// — радиус действия плантаций.
    case signal_range = "signal_range"
    /// — радиус обзора.
    case vision_range = "vision_range"
    /// — замедление деградации потерянных клеток.
    case decay_mitigation = "decay_mitigation"
    /// — снижение урона от землетрясений.
    case earthquake_mitigation = "earthquake_mitigation"
    /// — снижение урона от бобров.
    case beaver_damage_mitigation = "beaver_damage_mitigation"
}

class Tier: Codable {
    /// — кодовое имя апгрейда.
    let name: TierName
    /// — текущий уровень.
    let current: Int
    /// — максимальный уровень.
    let max: Int
}
