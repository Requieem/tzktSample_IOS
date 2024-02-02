//
//  URLSessionProtocol.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

/// Protocol for abstracting URLSession functionality.
/// This protocol is used to enable dependency injection for network requests, making the code more testable.
/// It defines the method to create a data task from a URLRequest.
public protocol URLSessionProtocol {
    /// Creates a data task with the provided request and completion handler.
    /// - Parameters:
    ///   - request: The URLRequest to create a data task for.
    ///   - completionHandler: The completion handler to call when the data task is completed.
    /// - Returns: A URLSessionDataTaskProtocol compliant object.
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

/// Protocol to abstract URLSessionDataTask functionality.
/// This protocol provides a method to resume a data task, essential for making network requests.
/// It's used alongside URLSessionProtocol to abstract the entire networking stack.
public protocol URLSessionDataTaskProtocol {
    /// Resumes the execution of the data task.
    func resume()
}

/// Extension to make URLSession conform to URLSessionProtocol.
/// Basic choice to provide a standard session for network requests.
extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

/// Extension to make URLSessionDataTask conform to URLSessionDataTaskProtocol.
/// This enables mocking of URLSessionDataTask in tests, by allowing the use of mock data task objects.
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

