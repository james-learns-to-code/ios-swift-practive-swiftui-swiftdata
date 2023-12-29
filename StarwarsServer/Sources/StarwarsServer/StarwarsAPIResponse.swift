//
//  StarwarsAPIResponse.swift
//  StarwarsApp
//
//  Created by Dongseok Lee on 12/29/23.
//

import Foundation

public struct StarwarsFilmsResponse: Codable {
    public let results: [StarwarsFilmResponse]?
}

public struct StarwarsFilmResponse: Codable {
    public let title: String?
    public let episode_id: Int?
    public let director: String?
}

