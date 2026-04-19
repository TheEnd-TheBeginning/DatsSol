//
//  DatsSolApp.swift
//  DatsSol
//
//  Created by Александра Савичева on 17.04.2026.
//

import SwiftUI

@main
struct DatsSolApp: App {
    let mapManager = MapManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mapManager)
        }
    }
}
