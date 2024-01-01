//
//  ContentView.swift
//  StarwarsModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        StarwarsView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StarwarsFilm.self, inMemory: true)
}
