//
//  MockURLSession.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import Foundation
@testable import tzktSample

/// A mock URLSession class for testing network calls.
/// This class conforms to URLSessionProtocol, allowing it to be used in place of a real URLSession in tests.
/// It provides mechanisms to set mock data, responses, and errors, enabling controlled testing of network logic.
class MockURLSession: URLSessionProtocol {
    /// Mock data to be returned by the mock session.
    var data: Data?

    /// Mock error to be simulated by the mock session.
    var error: Error?

    /// Mock URL response to be returned by the mock session.
    var response: URLResponse?

    /// Creates a mock data task with the provided request.
    /// This method does not perform any actual network call. Instead, it returns the predefined mock data, response, or error.
    /// - Parameters:
    ///   - request: The URLRequest for which the mock data task is created.
    ///   - completionHandler: The completion handler to call with the mock data, response, and error.
    /// - Returns: A mock URLSessionDataTaskProtocol compliant object.
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(data, response, error)
        return MockURLSessionDataTask()
    }
}

/// A mock URLSessionDataTask class for testing the resume() functionality of data tasks.
/// This class conforms to URLSessionDataTaskProtocol, allowing it to simulate the behavior of a real URLSessionDataTask.
/// It tracks whether the resume() method was called, which is a critical part of testing network requests.
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    /// Flag to track if the resume() method has been called on the data task.
    private(set) var resumeWasCalled = false

    /// Simulates the resume of a data task. Sets the `resumeWasCalled` flag to true.
    func resume() {
        resumeWasCalled = true
    }
}
