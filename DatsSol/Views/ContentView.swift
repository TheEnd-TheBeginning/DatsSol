//
//  ContentView.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(MapManager.self) private var mapManager
    
    var body: some View {
        VStack {
            NavigationStack {
                MapView()
                    .toolbar {
                        ToolbarItem {
                            let plantationPosition = mapManager.plantationPosition ?? [0,0]
                            Text("[x: \(plantationPosition.first!), y: \(plantationPosition.last!)]")
                                .frame(maxWidth: .infinity)
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button("Send repeated command", systemImage: "command") {
                                mapManager.sendRepeatedCommand()
                            }
                        }
                        
                        ToolbarItem {
                            Button("Stop repeated command", systemImage: "stop.circle") {
                                mapManager.stopRepeatedRequest()
                            }
                        }
                        
                        ToolbarItem {
                            Button("Reset chosen position", systemImage: "restart.circle") {
                                mapManager.stopRepeatedRequest()
                            }
                        }
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button("Update", systemImage: "arrow.clockwise") {
                                Task {
                                    do {
                                        try await mapManager.sendArenaRequest()
                                    } catch {
                                        throw error
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(MapManager())
}
