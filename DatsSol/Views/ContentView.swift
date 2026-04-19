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
                            let mainPlantationPosition = mapManager.arena?.plantations.first(where: { $0.isMain })?.position ?? [0,0]
                            Text("[x: \(mainPlantationPosition.first!), y: \(mainPlantationPosition.last!)]")
                                .frame(maxWidth: .infinity)
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
        .task {
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                Task {
//                    do {
//                        try await mapManager.sendArenaRequest()
//                    } catch {
//                        timer.invalidate()
//                        print(error.localizedDescription)
//                    }
//                }
//            }
            Task {
                do {
                    try await mapManager.sendArenaRequest()
                } catch {
                    print(error.localizedDescription)
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
