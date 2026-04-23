//
//  MeteoForecast.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

enum Kind: String, Codable {
    case earthquake = "earthquake"
    case sandstorm = "sandstorm"
}
//    Поля объекта `meteoForecasts[]` по Swagger:
//    - `kind` — тип события, например `earthquake` или `sandstorm`.
//    - `turnsUntil` — через сколько ходов событие произойдёт.
//    - Для землетрясения: `0` означает, что удар будет в этом ходу.
//    - Для песчаной бури: обычно используется только пока буря формируется.
//    - `id` — идентификатор бури.
//    - `forming` — `true`, если буря ещё формируется; `false`, если уже движется.
//    - `position` — текущий центр бури `[x, y]`.
//    - `nextPosition` — где будет центр бури на следующем шаге.
//    - `radius` — радиус бури.
class MeteoForecast: Codable {
    /// - `kind` — тип события, например `earthquake` или `sandstorm`.
    let kind: Kind
    /// - Для землетрясения: `0` означает, что удар будет в этом ходу.
    /// - Для песчаной бури: обычно используется только пока буря формируется.
    /// TurnsUntil: earthquake — turns until the quake (0 = this turn). Sandstorm — only while forming (turns until it starts moving); omitted when moving.
    let turnsUntil: Int?
    /// — идентификатор бури.
    /// ID: sandstorm-only identifier; changes when a new storm spawns.
    let id: String?
    /// — `true`, если буря ещё формируется; `false`, если уже движется.
    /// Sandstorm-only: true while gathering; false while moving (dealing damage each turn).
    let forming: Bool?
    /// — текущий центр бури `[x, y]`.
    /// Sandstorm-only while moving: center after the next step (omitted if the whole disk would leave the map)
    let position: [Int]?
    /// — где будет центр бури на следующем шаге.
    /// Sandstorm-only while moving: center after the next step (omitted if the whole disk would leave the map)
    let nextPosition: [Int]?
    /// — радиус бури.
    /// Sandstorm-only: disk radius r (cells satisfy dx²+dy² ≤ r²); config echo.
    let radius: Int?    
}
