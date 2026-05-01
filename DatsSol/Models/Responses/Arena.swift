//
//  Arena.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

class Arena: Decodable {
    /// - Номер текущего хода.
    let turnNo: Int
    /// - Через сколько секунд начнётся следующий ход.
    let nextTurnIn: Double
    /// - Размер карты в формате `[width, height]`.
    let size: [Int]
    /// - Радиус действия плантаций.
    /// - Обычно используется для проверки, можно ли строить, чинить или атаковать выбранную цель.
    let actionRange: Int
    /// - Список ваших плантаций.
    let plantations: [Plantation]
    /// - Список замеченных вражеских плантаций.
    let enemy: [Enemy]
    /// - Список клеток-гор, недоступных для терраформирования и строительства.
    /// - Каждая запись — координата `[x, y]`.
    let mountains: [[Int]]
    /// - Список известных терраформированных клеток
    let cells: [Cell]
    /// - Список строящихся плантаций.
    let construction: [Construction]
    /// - Список логов бобров или бобровых целей, доступных в текущем обзоре.
    let beavers: [Beaver]
    /// - Состояние системы апгрейдов.
    let plantationUpgrades: PlantationUpgrade
    ///- Прогноз катаклизмов.
    ///- Поле присутствует всегда, даже если прогнозов нет.
    let meteoForecasts: [MeteoForecast]
}

extension Arena {
    func getFieldType(actualPosition: [Int]) -> FieldType {
        if let plantation = plantations.first(where: { $0.position == actualPosition }) {
            return .myPlantation(plantation.isMain)
        }
        if let _ = enemy.first(where: { $0.position == actualPosition }) {
            return .enemyPlantation
        }
        if mountains.contains(actualPosition) == true {
            return .mountain
        }
        if let cell = cells.first(where: { $0.position == actualPosition }) {
            return .terraformed(cell.terraformationProgress)
        }
        if let _ = beavers.first(where: {$0.position == actualPosition }) {
            return .beaver
        }
        if let construction = construction.first(where: { $0.position == actualPosition }) {
            return .construction(construction.progress)
        }
        if let _ = meteoForecasts.first(where: { $0.position == actualPosition && $0.kind == .sandstorm }) {
            return .sandstorm(true)
        }
        if let _ = meteoForecasts.first(where: { $0.nextPosition == actualPosition && $0.kind == .sandstorm }) {
            return .sandstorm(false)
        }
        return .plain
    }
    
    func getFieldRadius(actualPosition: [Int]) -> CGFloat {
        if plantations.contains(where: { $0.position == actualPosition }) {
            return CGFloat(self.actionRange) * FieldManager.fieldScale
        }
        if let activeStorm = meteoForecasts.first(where: { $0.position == actualPosition && $0.kind == .sandstorm}),
           let radius = activeStorm.radius {
            return CGFloat(radius) * FieldManager.fieldScale
        }
        if beavers.contains(where: { $0.position == actualPosition }) {
            return Beaver.actionRange * FieldManager.fieldScale
        }
        return 0
    }
}
