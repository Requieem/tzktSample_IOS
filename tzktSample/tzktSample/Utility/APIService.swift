//
//  APIService.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

/// A simple helper class that can only handle GET requests
class APIService {
    private let session: URLSessionProtocol
    
    // Initialize with a URLSessionProtocol. Default is URLSession.shared.
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ urlString: String, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedResponse = try CustomJsonDecoder.shared.tzktJsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
