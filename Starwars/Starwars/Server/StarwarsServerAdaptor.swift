//
//  StarwarsServerAdaptor.swift
//  StarwarsMVVM
//
//  Created by Dongseok Lee on 12/30/23.
//

import Foundation
import StarwarsServer

extension StarwarsFilmResponse {
    func asModelData() -> StarwarsFilm? {
        guard let episodeId = episode_id else { return nil }
        return .init(
            title: title ?? "",
            episodeId: episodeId,
            director: director ?? ""
        )
    }
}
