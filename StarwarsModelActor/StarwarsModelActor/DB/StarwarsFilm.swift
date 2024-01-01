//
//  StarwarsFilm.swift
//  StarwarsApp
//
//  Created by Dongseok Lee on 12/29/23.
//

import Foundation
import SwiftData

typealias StarwarsFilm = StarwarsFilmSchemaV1.StarwarsFilm

enum StarwarsFilmSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [StarwarsFilm.self]
    }
    
    @Model
    final class StarwarsFilm {
        let title: String
        @Attribute(.unique)
        let episodeId: Int
        let director: String
        
        init(title: String, episodeId: Int, director: String) {
            self.title = title
            self.episodeId = episodeId
            self.director = director
        }
    }
}
