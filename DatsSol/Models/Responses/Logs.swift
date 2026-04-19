//
//  Logs.swift
//  DatsSol
//
//  Created by Александра Савичева on 18.04.2026.
//

import Foundation


/// Типичные сообщения, которые можно встретить в логах:
/// - спавн главной плантации
/// - применение апгрейда
/// - урон от землетрясения
/// - уничтожение плантации
/// - респавн после уничтожения
///
/// - Если токен ещё не зарегистрирован в игре, сервер отвечает не массивом логов, а ошибкой:
///
/// {
///   "code": 3,
///   "errors": [
///     "you are not registered in the game, please register first"
///   ]
/// }
//class Logs: Decodable {
//    let logs: [Log]
//}

struct Log: Decodable {
    /// время сообщения
    let time: String
    /// текст сообщения
    let message: String
}
