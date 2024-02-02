//
//  APIServiceTests.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import XCTest
@testable import tzktSample

class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiService = APIService(session: mockURLSession)
    }

    override func tearDown() {
        apiService = nil
        mockURLSession = nil
        super.tearDown()
    }

    func testFetchWithValidURLReturnsDecodedObject() {
        // Given
        let jsonData = """
        {
            "id": 1
        }
        """.data(using: .utf8)!
        mockURLSession.data = jsonData
        
        let expectation = self.expectation(description: "Valid URL and returned decoded object")
        
        // When
        var actualObject: MockDecodable?
        apiService.fetch("https://valid.url", decodingType: MockDecodable.self) { (result: Result<MockDecodable, Error>) in
            if case .success(let object) = result {
                actualObject = object
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(actualObject, MockDecodable(id: 1))
        }
    }

    func testFetchWithInvalidURLReturnsError() {
        // Given
        let expectation = self.expectation(description: "Invalid URL error")
        
        // When
        var actualError: Error?
        apiService.fetch("invalid url", decodingType: Data.self) { (result: Result<Data, Error>) in
            if case .failure(let error) = result {
                actualError = error
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(actualError)
            XCTAssert(actualError is NetworkError)
        }
    }

    func testFetchNoDataReturnsError() {
        // Given
        mockURLSession.data = nil
        let expectation = self.expectation(description: "No data error")
        
        // When
        var actualError: Error?
        apiService.fetch("https://valid.url", decodingType: Data.self) { (result: Result<Data, Error>) in
            if case .failure(let error) = result {
                actualError = error
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(actualError)
        }
    }

    func testFetchWithErrorReturnsError() {
        // Given
        let expectedError = NSError(domain: "", code: 0, userInfo: nil)
        mockURLSession.error = expectedError
        let expectation = self.expectation(description: "Network error")
        
        // When
        var actualError: Error?
        apiService.fetch("https://valid.url", decodingType: Data.self) { (result: Result<Data, Error>) in
            if case .failure(let error) = result {
                actualError = error
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(actualError)
        }
    }

    func testFetchWithDecodingErrorReturnsError() {
        // Given
        let invalidData = "invalid data".data(using: .utf8)
        mockURLSession.data = invalidData
        let expectation = self.expectation(description: "Decoding error")
        
        // When
        var actualError: Error?
        apiService.fetch("https://valid.url", decodingType: MockDecodable.self) { (result: Result<MockDecodable, Error>) in
            if case .failure(let error) = result {
                actualError = error
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(actualError)
        }
    }

    // Additional tests can be implemented similarly for different HTTP status codes,
    // different `Decodable` types, and other edge cases.
}
