//
//  StarwarsModelActor.swift
//  StarwarsModelActor
//
//  Created by Dongseok Lee on 1/1/24.
//

import Foundation
import os.log
import SwiftData
import StarwarsServer

private let logger = Logger(subsystem: "com.goodeffect.Starwars", category: "StarwarsView")

@ModelActor
actor StarwarsModelActor {
    func addFilms(_ films: [StarwarsFilm]) async {
        films.forEach { film in
            modelContext.insert(film)
        }
        
        save()
    }
    
    func fetchFilms() async -> [StarwarsFilm] {
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
    
    func addNewFilm(_ film: StarwarsFilm) async {
        modelContext.insert(film)
        
        save()
    }
    
    func deleteFilms(_ films: [StarwarsFilm]) async {
        films.forEach { film in
            let id = film.persistentModelID
            let model = modelContext.model(for: id)
            modelContext.delete(model)
        }
        
        save()
    }
}
