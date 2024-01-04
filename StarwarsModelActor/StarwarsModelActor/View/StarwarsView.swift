//
//  StarwarsView.swift
//  Starwars
//
//  Created by Dongseok Lee on 12/29/23.
//

import SwiftUI
import SwiftData

struct StarwarsView: View {
    @Environment(\.modelContext) private var modelContext
        
    private var modelActor: StarwarsModelActor {
        StarwarsModelActor(modelContainer: modelContext.container)
    }

    @Query(sort: \StarwarsFilm.episodeId) private var films: [StarwarsFilm]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(films) { film in
                    Text(film.title + " " + film.director)
                        .animation(.easeInOut)
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
            if films.isEmpty {
                await modelActor.loadFilms()
            }
        }
    }
    
    private func addNewFilm() {
        let maxId = films.map(\.episodeId).max()
        let nextId = (maxId ?? 0) + 1
        modelActor.addNewFilm(id: nextId)
    }
    
    private func deleteFilms(offsets: IndexSet) {
        let ids = offsets.map { films[$0] }.map { $0.persistentModelID }
        modelActor.deleteFilms(ids: ids)
    }
}
