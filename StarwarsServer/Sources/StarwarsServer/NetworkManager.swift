//
//  NetworkManager.swift
//  BaseProject
//
//  Created by dongseok lee on 15/06/2019.
//  Copyright © 2019 Good Effect. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case response(error: Error?)
    case data
    case jsonDecoding(error: Error?)
    
    var localizedDescription: String {
        let customDescription: String?
        switch self {
        case .response(let error):
            customDescription = error?.localizedDescription
        case .jsonDecoding(let error):
            customDescription = error?.localizedDescription
        default:
            customDescription = nil
        }
        return customDescription ?? ""
    }
}

public class NetworkManager {
    
    // MARK: Interface
    @discardableResult
    func request(
        with url: URL,
        type: RequestType,
        handler: @escaping DataResultHandler) -> URLSessionDataTask? {
            
            var req = URLRequest(url: url)
            req.httpMethod = type.httpMethod
            req.allHTTPHeaderFields = NetworkManager.header
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            return request(with: session, req, handler)
        }
    
    func request(
        with url: URL,
        type: RequestType
    ) async throws -> Data {
        
        var req = URLRequest(url: url)
        req.httpMethod = type.httpMethod
        req.allHTTPHeaderFields = NetworkManager.header
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return try await request(with: session, req)
    }
    
    // MARK: Request
    
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
        
        var httpMethod: String {
            return rawValue
        }
    }
    
    private static let header: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    typealias DataResult = Result<Data, NetworkError>
    typealias DataResultHandler = (DataResult) -> Void
    
    private func request(
        with session: URLSession,
        _ request: URLRequest,
        _ handler: @escaping DataResultHandler) -> URLSessionDataTask {
            
            let task = session.dataTask(with: request) {
                (responseData, response, responseError) in
                
                guard responseError == nil else {
                    handler(.failure(.response(error: responseError)))
                    return
                }
                guard let data = responseData else {
                    handler(.failure(.data))
                    return
                }
                handler(.success(data))
            }
            task.resume()
            return task
        }
    
    private func request(
        with session: URLSession,
        _ request: URLRequest
    ) async throws -> Data {
        let (data, _) = try await session.data(for: request)
        return data
    }
}

// MARK: Decoder
extension NetworkManager {
    struct Decoder<Type: Decodable> {
        static func decodeResult(
            _ result: DataResult,
            handler: @escaping (Result<Type, NetworkError>) -> Void) {
                
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let value = try decoder.decode(Type.self, from: data)
                        handler(.success(value))
                    } catch {
                        handler(.failure(.jsonDecoding(error: error)))
                    }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        
        static func decodeResult(
            _ data: Data
        ) throws -> Type {
            let decoder = JSONDecoder()
            return try decoder.decode(Type.self, from: data)
        }
    }
}

// MARK: Convenience
extension NetworkManager {
    @discardableResult
    func request(
        with urlString: String,
        type: RequestType,
        handler: @escaping DataResultHandler) -> URLSessionDataTask? {
            guard let url = URL(string: urlString) else {
                handler(.failure(.url))
                return nil
            }
            return request(with: url, type: type, handler: handler)
        }
    
    func request(
        with urlString: String,
        type: RequestType
    ) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.url
        }
        return try await request(with: url, type: type)
    }
}
