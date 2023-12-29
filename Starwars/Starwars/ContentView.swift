//
//  ContentView.swift
//  StarwarsApp
//
//  Created by Dongseok Lee on 12/29/23.
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
