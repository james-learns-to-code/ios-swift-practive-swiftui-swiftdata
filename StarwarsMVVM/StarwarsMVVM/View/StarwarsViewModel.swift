//
//  StarwarsViewModel.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import os.log
import SwiftUI
import SwiftData
@preconcurrency import StarwarsServer

private let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsViewModel")

@MainActor
final class StarwarsViewModel: ObservableObject {
    private let modelContext: ModelContext
    
    @Published var films: [StarwarsFilm] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadFilmsIfEmpty() async {
        fetchFilmData()

        guard films.isEmpty else { return }
        
        do {
            let response = try await StarwarsNetworkManager.shared.requestFilmList()
            let films = response.results?.compactMap { $0.asModelData() } ?? []
            
            updateFilms(films)
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }
    
    private func fetchFilmData() {
        do {
            let descriptor = FetchDescriptor<StarwarsFilm>(sortBy: [SortDescriptor(\.episodeId)])
            films = try modelContext.fetch(descriptor)
        } catch {
            logger.error("Fetch failed: \(error)")
        }
    }
    
    private func updateFilms(_ films: [StarwarsFilm]) {
        films.forEach { film in
            modelContext.insert(film)
        }
        
        updateModelData()
    }
    
    private func updateModelData() {
        do {
            try modelContext.save()
            
            fetchFilmData()
            
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }
    
    func addNewFilm() {
        let maxId = films.map(\.episodeId).max()
        let nextId = (maxId ?? 0) + 1
        let newFilm = StarwarsFilm(title: "New", episodeId: nextId, director: "Unknown")
        modelContext.insert(newFilm)
        
        updateModelData()
        
        // For demonstration. Not actually sync with server
    }
    
    func deleteFilms(offsets: IndexSet) {
        offsets.forEach { index in
            modelContext.delete(films[index])
        }
        
        updateModelData()
        
        // For demonstration. Not actually sync with server
    }
}
