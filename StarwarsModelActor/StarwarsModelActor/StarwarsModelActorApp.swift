//
//  StarwarsModelActorApp.swift
//  StarwarsModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import SwiftUI
import SwiftData

@main
struct StarwarsModelActorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StarwarsFilm.self)
    }
}
