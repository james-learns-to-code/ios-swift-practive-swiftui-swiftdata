//
//  StarwarsMVVMApp.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import SwiftUI
import SwiftData

/*
 This app is demonstrate SwiftUI + ViewModel + SwiftData + REST API integration
 Instead of using Query, Manually fetching SwiftData for using ViewModel
 */
@main
struct StarwarsMVVMApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: StarwarsFilm.self, isAutosaveEnabled: false)
    }
}
