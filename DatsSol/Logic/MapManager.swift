//
//  MapManager.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import Foundation
internal import Combine

@Observable
class MapManager {
    var mapSize: (x: Int, y: Int) = (0,0)
    var scaleFactor: CGFloat = 50
    var areaRadius: Int = 10
    var arena: Arena?
    var xShift = 0
    var yShift = 0
    var timerIterator = 0
    let network = Network()
    var repeatingTask: Task<Void, Error>?
    
    var plantationPosition: [Int]? {
        return arena?.plantations.first(where: { $0.isMain })?.position
    }
    var chosenPosition: [Int]?
    
    enum ArenaError: Error {
        case noData(String)
        case unexpectedNil
    }
    
    func sendArenaRequest() async throws {
        do {
            if let arenaData = try await network.sendRequest(httpMethod: .get, apiMethod: .arena) {
                print(String(data: arenaData, encoding: .utf8)!)
                let oldMainPosition = self.plantationPosition
                arena = try JSONDecoder().decode(Arena.self, from: arenaData)
                guard let arena, arena.turnNo != 0 else { throw ArenaError.noData("No data") }
                if oldMainPosition != self.plantationPosition {
                    self.chosenPosition = choosePosition()
                }
                setSize()
            }
        } catch {
            throw error
        }
    }
    
    func sendRepeatedCommand() {
        self.repeatingTask?.cancel()
        
        self.repeatingTask = Task {
            try await sendArenaRequest()
            self.chosenPosition = choosePosition()
            
            while !Task.isCancelled {
                do {
                    guard let plantationPosition, let chosenPosition, let arena else {
                        stopRepeatedRequest()
                        throw ArenaError.unexpectedNil
                    }
                    
                    var commandPath = CommandPath(path: [plantationPosition, plantationPosition, chosenPosition])
                    var relocateMain: [[Int]]? = nil
                    var plantationUpgrade: TierName? = TierName.allCases.randomElement()
                    
                    if arena.plantations.contains(where: { $0.position == chosenPosition }) {
                        let oldChosenPosition = chosenPosition
                        
                        if let newChosenPosition = choosePosition(currentPosition: oldChosenPosition) {
                            commandPath.path = [oldChosenPosition, oldChosenPosition, newChosenPosition]
                            relocateMain = [plantationPosition, oldChosenPosition]
                            plantationUpgrade = nil
                            self.chosenPosition = newChosenPosition
                        }
                    }
                    
                    
                    try await self.sendCommandRequest(command: [commandPath],
                                                      plantationUpgrade: plantationUpgrade,
                                                      relocateMain: relocateMain)
                    
                    try await sendArenaRequest()
                    
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    stopRepeatedRequest()
                    throw error
                }
            }
        }
    }
    
    func stopRepeatedRequest() {
        self.repeatingTask?.cancel()
        self.chosenPosition = nil
        Task {
            try await self.sendArenaRequest()
        }
    }
    
    func sendCommandRequest(command: [CommandPath]? = nil,
                            plantationUpgrade: TierName? = nil,
                            relocateMain: [[Int]]? = nil) async throws {
        do {
            let commandJson = Command.Request(command: command,
                                              plantationUpgrade: plantationUpgrade,
                                              relocateMain: relocateMain)
            let jsonData = try JSONEncoder().encode(commandJson)

            if let commandData = try await self.network.sendRequest(httpMethod: .post, apiMethod: .command, bodyData: jsonData) {
                print(String(data: commandData, encoding: .utf8)!)
                let commandResponse = try JSONDecoder().decode(Command.Response.self, from: commandData)
            }
        } catch {
            throw error
        }
    }
    
    func choosePosition(currentPosition: [Int]? = nil) -> [Int]? {
        guard let currentPosition = currentPosition ?? self.plantationPosition else {
            return nil
        }
        let x = currentPosition.first!
        let y = currentPosition.last!
        let potentialPositions = [
            [x + 1, y],
            [x, y + 1],
            [x - 1, y],
            [x, y - 1],
            [x + 1, y + 1],
            [x - 1, y - 1],
            [x + 1, y - 1],
            [x - 1, y + 1]
        ]
        for potentialPosition in potentialPositions {
            guard let arena else { return nil }
            if !arena.plantations.contains(where: { $0.position == potentialPosition }) &&
                !arena.enemy.contains(where: { $0.position == potentialPosition }) &&
                !arena.mountains.contains(potentialPosition) &&
                !arena.meteoForecasts.contains(where: {
                    $0.position == potentialPosition ||
                    $0.nextPosition == potentialPosition
                }) &&
                !arena.cells.contains(where: { $0.position == potentialPosition }) &&
                !arena.beavers.contains(where: {$0.position == potentialPosition }){
                return potentialPosition
            }
        }
        return nil
    }
    
    func sendLogsRequest() async throws {
        do {
            if let logsData = try await network.sendRequest(httpMethod: .get, apiMethod: .logs) {
                let _ = try JSONDecoder().decode([Log].self, from: logsData)
                print(String(data: logsData, encoding: .utf8)!)
            }
        } catch {
            throw error
        }
    }
    
    private func setSize() {
        guard let arena else { return }
        var minX = Int.max
        var maxX = 0
        var minY = Int.max
        var maxY = 0
        for plantation in arena.plantations {
            let position = plantation.position
            if position.first! < minX {
                minX = position.first!
            }
            if position.first! > maxX {
                maxX = position.first!
            }
            if position.last! < minY {
                minY = position.last!
            }
            if position.last! > maxY {
                maxY = position.last!
            }
        }
        
        minX = max(minX - areaRadius, 0)
        maxX = min(maxX + areaRadius, arena.size.first!)
        minY = max(minY - areaRadius, 0)
        maxY = min(maxY + areaRadius, arena.size.last!)
        
        let width = minX == maxX ? minX : maxX - minX
        let height = minY == maxY ? minY : maxY - minY
        
        xShift = minX == maxX ? 0 : minX
        yShift = minY == maxY ? 0 : minY
        mapSize = (width, height)
    }
}
