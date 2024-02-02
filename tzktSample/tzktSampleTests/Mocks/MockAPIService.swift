//
//  MockAPIService.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import Foundation
@testable import tzktSample

/// A mock version of `APIService` used for testing.
/// This class allows you to simulate network responses for different URLs, making it easier to test network-related logic.
/// It overrides the `fetch` method of `APIService` to return predefined responses instead of performing actual network requests.
class MockAPIService: APIService {
    /// A dictionary that maps URL strings to mock responses.
    /// Each URL string is associated with a tuple containing optional data and an optional error.
    /// This allows you to set up different responses for different network requests in your tests.
    var mockResponses: [String: (data: Data?, error: Error?)] = [:]

    /// Overrides the `fetch` method to provide mock responses based on the URL.
    /// It simulates network requests and responses, bypassing actual HTTP calls.
    /// - Parameters:
    ///   - urlString: The URL string for the network request.
    ///   - decodingType: The type of the model to which the response data should be decoded.
    ///   - completion: The completion handler to call with either the decoded model or an error.
    /// - Note: The method checks `mockResponses` for a matching URL and returns the associated response. If no match is found, it returns a `noData` error.
    override func fetch<T>(_ urlString: String, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let response = mockResponses[urlString] ?? (nil, nil)

        // Checks if an error is set for the given URL and returns it.
        if let error = response.error {
            completion(.failure(error))
            return
        }
        
        // If mock data is provided, attempts to decode it into the requested type and returns the result.
        if let data = response.data {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        } else {
            // If neither data nor error is provided, returns a `noData` error.
            completion(.failure(NetworkError.noData))
        }
    }
}

