//
//  MockAPIService.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import Foundation
@testable import tzktSample

// A Mock APIService to simulate network responses
class MockAPIService: APIService {
    // Dictionary to map URLs to mock responses
    var mockResponses: [String: (data: Data?, error: Error?)] = [:]

    override func fetch<T>(_ urlString: String, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let response = mockResponses[urlString] ?? (nil, nil)

        if let error = response.error {
            completion(.failure(error))
            return
        }
        
        if let data = response.data {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
}

