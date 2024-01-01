//
//  StarwarsMVVMModelActorApp.swift
//  StarwarsMVVMModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import SwiftUI
import SwiftData

@main
struct StarwarsMVVMModelActorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StarwarsFilm.self, isAutosaveEnabled: false)
    }
}
