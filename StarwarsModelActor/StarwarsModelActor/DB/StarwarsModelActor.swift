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
    func loadFilms() async {
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
        
    private func save() {
        do {
            try modelContext.save()
        } catch {
            logger.error("An error occurred: \(error)")
        }
    }

    nonisolated func addNewFilm(id: Int) {
        Task {
            await _addNewFilm(id: id)
        }
    }
    
    private func _addNewFilm(id: Int) {
        let newFilm = StarwarsFilm(title: "New", episodeId: id, director: "Unknown")
        
        modelContext.insert(newFilm)

        save()

        // For demonstration. Not actually sync with server
    }
    
    nonisolated func deleteFilms(ids: [PersistentIdentifier]) {
        Task {
            await _deleteFilms(ids: ids)
        }
    }
    
    private func _deleteFilms(ids: [PersistentIdentifier]) {
        ids.forEach { id in
            let model = modelContext.model(for: id)
            modelContext.delete(model)
        }

        save()
        
        // For demonstration. Not actually sync with server
    }
}
