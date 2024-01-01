//
//  StarwarsViewModel.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import os.log
import SwiftUI
import SwiftData
import StarwarsServer

private let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsViewModel")

@MainActor
final class StarwarsViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    private var modelActor: StarwarsModelActor {
        StarwarsModelActor(modelContainer: modelContext.container)
    }

    @Published var films: [StarwarsFilm] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadFilmsIfEmpty() async {
        await fetchFilmData()
        
        guard films.isEmpty else { return }
        
        await loadFilms()
    }
    
    private func loadFilms() async {
        do {
            let response = try await StarwarsNetworkManager.shared.requestFilmList()
            let films = response.results?.compactMap { $0.asModelData() } ?? []

            await modelActor.addFilms(films)
            
            await fetchFilmData()
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }
    
    private func fetchFilmData() async {
        films = await modelActor.fetchFilms()
    }
    
    func addNewFilm() async {
        let maxId = films.map(\.episodeId).max()
        let nextId = (maxId ?? 0) + 1
        let newFilm = StarwarsFilm(title: "New", episodeId: nextId, director: "Unknown")

        await modelActor.addNewFilm(newFilm)

        await fetchFilmData()
        
        // For demonstration. Not actually sync with server
    }
    
    func deleteFilms(offsets: IndexSet) async {
        let deletes = offsets.map { films[$0] }
        await modelActor.deleteFilms(deletes)
        
        await fetchFilmData()
        
        // For demonstration. Not actually sync with server
    }
}
