//
//  StartwarsApp.swift
//  Startwars
//
//  Created by Dongseok Lee on 12/29/23.
//

import SwiftUI
import SwiftData

/*
 This App is demonstrate SwiftUI + SwiftData + REST API integration
 */
@main
struct StartwarsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StarwarsFilm.self)
    }
}