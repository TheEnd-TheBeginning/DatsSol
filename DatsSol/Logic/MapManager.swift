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
    
    enum ArenaError: Error {
        case noData(String)
    }
    
    func sendArenaRequest() async throws {
        do {
            if let arenaData = try await network.sendRequest(httpMethod: .get, apiMethod: .arena) {
                print(String(data: arenaData, encoding: .utf8)!)
                arena = try JSONDecoder().decode(Arena.self, from: arenaData)
                guard let arena, arena.turnNo != 0 else { return }
//                areaRadius = arena.actionRange * 10
                setSize()
            }
        } catch {
            throw error
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
            
            if let commandData = try await network.sendRequest(httpMethod: .post, apiMethod: .command, bodyData: jsonData) {
                print(String(data: commandData, encoding: .utf8)!)
                let commandResponse = try JSONDecoder().decode(Command.Response.self, from: commandData)
            }
            
            try await sendArenaRequest()
        } catch {
            throw error
        }
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
