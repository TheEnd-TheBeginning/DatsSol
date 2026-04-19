//
//  Command.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation

struct CommandPath: Codable {
    /// "path": [
    /// [x1, y1],
    /// [x2, y2],
    /// [x3, y3]
    /// ]
    /// где:
    /// первая координата - автор команды.
    /// вторая координата - выходная точка команды. может быть сам автор.
    /// третья координата - цель команды.
    var path: [[Int]]
}

class Command {
    /// Важно:
    /// - Сервер ожидает, что в ходе будет отправлено хотя бы одно полезное действие:
    /// `command`, или `plantationUpgrade`, или `relocateMain`.
    /// - Иначе можно получить ошибку вида:
    /// `empty command: no plantation actions, no relocateMain, and no plantationUpgrade provided
    class Request: Encodable {
        /// - Массив действий плантаций.
        /// Практическое пояснение:
        /// - Тип действия определяется конечной целью.
        /// - своя плантация в конце маршрута — ремонт;
        /// - чужая плантация — диверсия;
        /// - логово/цель бобров — атака;
        /// - пустая клетка — строительство;
        let command: [CommandPath]?
        
        ///- Название апгрейда, который нужно купить в этом ходу.
        ///- Пример: `repair_power`.
        let plantationUpgrade: String?
        
        ///- Маршрут переноса ЦУ.
        ///- Формат такой же, как у `path`: массив координат.
        ///- Минимально это выглядит как:
        ///`[[fromX, fromY], [toX, toY]]`
        let relocateMain: [[Int]]?
        
        init(command: [CommandPath]? = nil,
             plantationUpgrade: TierName? = nil,
             relocateMain: [[Int]]? = nil) {
            self.command = command
            self.plantationUpgrade = plantationUpgrade?.rawValue
            self.relocateMain = relocateMain
        }
    }
    
    class Response: Decodable {
        /// - Числовой код результата.
        /// - В наблюдаемом успешном ответе приходит `0`.
        let code: Int
        
        /// - Список текстовых ошибок.
        /// - При успешной отправке обычно это пустой массив `[]`.
        let errors: [String]
    }
}
