//
//  StarwarsView.swift
//  Starwars
//
//  Created by Dongseok Lee on 12/29/23.
//

import os.log
import SwiftUI
import SwiftData

let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsView")

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
            await modelActor.loadFilmsIfEmpty()
        }
    }
    
    private func addNewFilm() {
        Task {
            await modelActor.addNewFilm()
        }
    }
    
    private func deleteFilms(offsets: IndexSet) {
        Task {
            await modelActor.deleteFilms(offsets: offsets)
        }
    }
}
