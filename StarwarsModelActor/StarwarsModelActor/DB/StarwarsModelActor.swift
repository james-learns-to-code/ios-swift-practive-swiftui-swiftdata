//
//  StarwarsModelActor.swift
//  StarwarsModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import Foundation
import SwiftData
import StarwarsServer

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
    
    private func fetchFilms() -> [StarwarsFilm] {
        do {
            let descriptor = FetchDescriptor<StarwarsFilm>()
            return try modelContext.fetch(descriptor)
        } catch {
            logger.error("Fetch failed")
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

    func addNewFilm() async {
        let films = fetchFilms()
        let maxId = films.map(\.episodeId).max()
        let nextId = (maxId ?? 0) + 1
        let newFilm = StarwarsFilm(title: "New", episodeId: nextId, director: "Unknown")
        modelContext.insert(newFilm)

        save()

        // For demonstration. Not actually sync with server
    }
    
    func deleteFilms(offsets: IndexSet) async {
        let films = fetchFilms()
        offsets.forEach { index in
            modelContext.delete(films[index])
        }
        
        save()

        // For demonstration. Not actually sync with server
    }
}
