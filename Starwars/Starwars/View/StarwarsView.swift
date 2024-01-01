//
//  StarwarsView.swift
//  Starwars
//
//  Created by Dongseok Lee on 12/29/23.
//

import os.log
import SwiftUI
import SwiftData
import StarwarsServer

let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsView")

struct StarwarsView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \StarwarsFilm.episodeId) private var films: [StarwarsFilm]

    var body: some View {
        NavigationView {
            List {
                ForEach(films) { film in
                    Text(film.title + " " + film.director)
                }
                .onDelete(perform: deleteFilms)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addNewFilm) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.task {
            await loadFilmsIfEmpty()
        }
    }
    
    private func loadFilmsIfEmpty() async {
        guard films.isEmpty else { return }

        do {
            let response = try await StarwarsNetworkManager.shared.requestFilmList()
            let films = response.results?.compactMap { $0.asModelData() } ?? []
            
            films.forEach { film in
                modelContext.insert(film)
            }
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }
    
    private func addNewFilm() {
        withAnimation {
            let maxId = films.map(\.episodeId).max()
            let nextId = (maxId ?? 0) + 1
            let newFilm = StarwarsFilm(title: "New", episodeId: nextId, director: "Unknown")
            modelContext.insert(newFilm)
        }
        
        // For demonstration. Not actually sync with server
    }
    
    private func deleteFilms(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                modelContext.delete(films[index])
            }
        }
        
        // For demonstration. Not actually sync with server
    }
}
