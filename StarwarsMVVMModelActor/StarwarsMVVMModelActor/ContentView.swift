//
//  ContentView.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        StarwarsView(viewModel: StarwarsViewModel(modelContext: modelContext))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StarwarsFilm.self, inMemory: true, isAutosaveEnabled: false)
}
