//
//  StarwarsModelActor.swift
//  StarwarsModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import Foundation
import os.log
import SwiftData
@preconcurrency import StarwarsServer

private let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsView")

@ModelActor
actor StarwarsModelActor {
    func loadFilmsIfEmpty() async {
        let films = fetchFilms()

        guard films.isEmpty else { return }
        
        do {
            let response = try await StarwarsNetworkManager.shared.requestFilmList()
            let films = response.results?.compactMap { $0.asModelData() } ?? []
            
            films.forEach { film in
                modelContext.insert(film)
            }
            
            save()
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }
    
    private func fetchFilms() -> [StarwarsFilm] {
        do {
            let descriptor = FetchDescriptor<StarwarsFilm>(sortBy: [SortDescriptor(\.episodeId)])
            return try modelContext.fetch(descriptor)
        } catch {
            logger.error("Fetch failed: \(error)")
            return []
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }

    nonisolated func addNewFilm() {
        Task {
            await _addNewFilm()
        }
    }
    
    private func _addNewFilm() {
        let films = fetchFilms()
        let maxId = films.map(\.episodeId).max()
        let nextId = (maxId ?? 0) + 1
        let newFilm = StarwarsFilm(title: "New", episodeId: nextId, director: "Unknown")
        
        modelContext.insert(newFilm)

        save()

        // For demonstration. Not actually sync with server
    }
    
    nonisolated func deleteFilms(offsets: IndexSet) {
        Task {
            await _deleteFilms(offsets: offsets)
        }
    }
    
    private func _deleteFilms(offsets: IndexSet) {
        let films = fetchFilms()
        offsets.forEach { index in
            modelContext.delete(films[index])
        }

        save()
        
        // For demonstration. Not actually sync with server
    }
}
