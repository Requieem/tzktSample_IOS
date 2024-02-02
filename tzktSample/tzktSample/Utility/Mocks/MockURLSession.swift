//
//  MockURLSession.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(data, nil, error)
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        // Mock resume
    }
}
