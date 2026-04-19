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
