//
//  StarwarsMVVMApp.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import SwiftUI
import SwiftData

@main
struct StarwarsMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StarwarsFilm.self, isAutosaveEnabled: false)
    }
}
