//
//  MockURLSession.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import Foundation
@testable import tzktSample

// MockURLSession conforms to the URLSessionProtocol and allows for test data injection.
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    var response: URLResponse?

    // We keep track of the last URL request that was handled by the mock session.
    private(set) var lastURL: URL?

    // This function simulates a network call and directly returns the data and error that you set on the mock session.
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(data, response, error)
        return MockURLSessionDataTask()
    }
}

// MockURLSessionDataTask conforms to URLSessionDataTaskProtocol and allows you to test the resume() method call.
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}
