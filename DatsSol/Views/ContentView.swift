//
//  ContentView.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(MapManager.self) private var mapManager
    @State private var needTeleport: Bool = false
    @State private var scale: CGFloat = 1
    private let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    
    var maxScale: CGFloat {
        return horizontalSizeClass == .compact ? 1 : 3
    }
    var minScale: CGFloat {
        return horizontalSizeClass == .compact ? 0.19 : 0.41
    }
    
    var arenaRadius: CGFloat {
        return CGFloat(mapManager.arenaRadius)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(ImageResource.spaceBackground)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(alignment: .center) {
                    Spacer()
                    MapView(needTeleport: $needTeleport, scale: $scale)
                    
                    Spacer()
                    LazyVStack(alignment: .center) {
                        Button("Teleport to Main") {
                            needTeleport = true
                        }
                        .buttonStyle(.bordered)
                        
                        Slider(value: $scale, in: minScale...maxScale, step: 0.15)
                            .frame(width: 300)
                    }
                    .padding()
                }
                .frame(maxWidth: horizontalSizeClass == .compact ? .infinity : arenaRadius * mapManager.scaleFactor, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                needTeleport = true
                            } catch {
                                throw error
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(MapManager.shared)
}
