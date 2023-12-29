//
//  StarwarsNetworkManager.swift
//  BaseProject
//
//  Created by leedongseok on 14/06/2019.
//  Copyright © 2019 Good Effect. All rights reserved.
//

import Foundation

public final class StarwarsNetworkManager: NetworkManager {
    public static let shared = StarwarsNetworkManager()
    
    private struct URL {
        static let base = "https://swapi.dev/api/"
        static let filmPath = "films/"
        static let film = base + filmPath
    }
}

// MARK: API
extension StarwarsNetworkManager {
    func requestFilmList(
        handler: @escaping (Result<StarwarsFilmsResponse, NetworkError>) -> Void) {
            request(
                with: StarwarsNetworkManager.URL.film,
                type: .get
            ) { result in
                Decoder<StarwarsFilmsResponse>
                    .decodeResult(result, handler: handler)
            }
        }
    
    public func requestFilmList() async throws -> StarwarsFilmsResponse {
        let data = try await request(
            with: StarwarsNetworkManager.URL.film,
            type: .get
        )
        return try Decoder<StarwarsFilmsResponse>.decodeResult(data)
    }
}
