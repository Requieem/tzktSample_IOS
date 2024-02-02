//
//  VM_BlockTableTests.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import XCTest
@testable import tzktSample

class VM_BlockTableTests: XCTestCase {

    var viewModel: VM_BlockTable!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = VM_BlockTable(apiService: mockAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchBlocksProcessesSuccessfully() {
        // Given
        let blocksURL = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=0&limit=10"
        let transactionCountURL = "https://api.tzkt.io/v1/operations/transactions/count?level=123"
        
        let mockBlocks = [Block(level: 123, timestamp: Date(), proposer: Account(alias: "Test", address: "address"))]
        let mockTransactionCount = 10

        let mockBlocksData = try? JSONEncoder().encode(mockBlocks)
        let mockTransactionCountData = try? JSONEncoder().encode(mockTransactionCount)

        mockAPIService.mockResponses[blocksURL] = (mockBlocksData, nil)
        mockAPIService.mockResponses[transactionCountURL] = (mockTransactionCountData, nil)
        
        let expectation = self.expectation(description: "Fetch and process blocks")

        // When
        viewModel.fetchBlocks()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.blocks, mockBlocks)
            XCTAssertEqual(self.viewModel.blocks.first?.transactionCount, mockTransactionCount)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
    
    func testFetchBlocksFailure() {
        // Given
        let urlString = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=\(viewModel.offset)&limit=\(viewModel.limit)"
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        mockAPIService.mockResponses[urlString] = (nil, error)

        let expectation = self.expectation(description: "Fetch blocks failure")
        
        // When
        viewModel.fetchBlocks()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.blocks.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
    }

    func testProcessFetchedBlocksWithEmptyArray() {
        // Given
        let emptyBlocks: [Block] = []

        // When
        viewModel.processFetchedBlocks(emptyBlocks)

        // Then
        XCTAssertTrue(viewModel.blocks.isEmpty)
    }

    func testFetchTransactionCountFailure() {
        // Given
        let level = 123
        let urlString = "https://api.tzkt.io/v1/operations/transactions/count?level=\(level)"
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        mockAPIService.mockResponses[urlString] = (nil, error)
        
        let expectation = self.expectation(description: "Fetch transaction count failure")
        
        // When
        viewModel.fetchTransactionCount(for: level) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { _ in
            // Then
            XCTAssertNotNil(self.viewModel.lastError)
        }
    }

    // Test offset handling when duplicate blocks are fetched
    func testOffsetHandlingWithDuplicateBlocks() {
        // Given
        let mockBlocks = [Block(level: 1, timestamp: Date(), proposer: Account(alias: "Test", address: "address"))]
        viewModel.blocks = mockBlocks // Assume initial set of blocks
        let urlString = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=\(viewModel.offset)&limit=\(viewModel.limit)"
        mockAPIService.mockResponses[urlString] = (try? JSONEncoder().encode(mockBlocks), nil)
        
        // When
        viewModel.fetchBlocks()
        
        // Then
        XCTAssertEqual(viewModel.offset, 1) // Assuming offset is updated as per number of duplicates
    }

    // Test processing blocks when fetchTransactionCount fails
    func testProcessBlocksWithTransactionCountFailure() {
        // Given
        let mockBlocks = [Block(level: 1, timestamp: Date(), proposer: Account(alias: "Test", address: "address")),
                          Block(level: 2, timestamp: Date(), proposer: Account(alias: "Test2", address: "address2"))]
        let urlString = "https://api.tzkt.io/v1/operations/transactions/count?level=1"
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        mockAPIService.mockResponses[urlString] = (nil, error)

        // When
        viewModel.processFetchedBlocks(mockBlocks)
        
        // Then
        XCTAssertEqual(viewModel.blocks.count, 0)
    }
}
