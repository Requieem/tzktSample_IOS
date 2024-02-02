//
//  VM_TransactionTableTests.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import XCTest
@testable import tzktSample

class VM_TransactionTableTests: XCTestCase {

    var viewModel: VM_TransactionTable!
    var mockAPIService: MockAPIService!
    var testBlock: Block!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        testBlock = Block(level: 123, timestamp: Date(), proposer: Account(alias: "Test", address: "address"))
        viewModel = VM_TransactionTable(block: testBlock, apiService: mockAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        testBlock = nil
        super.tearDown()
    }

    func testFetchTransactionsSuccess() {
        // Given
        let transactionsURL = "https://api.tzkt.io/v1/operations/transactions?level=\(testBlock.level)&offset=0&limit=10"
        let mockTransactions = [Transaction(sender: Account(alias: "account1", address: "address1"), target: Account(alias: "account2", address: "address2"), amount: 10, status: "accepted", id: 1), Transaction(sender: Account(alias: "account3", address: "address3"), target: Account(alias: "account4", address: "address4"), amount: 10, status: "accepted", id: 2)]
        let mockTransactionsData = try? JSONEncoder().encode(mockTransactions)
        mockAPIService.mockResponses[transactionsURL] = (mockTransactionsData, nil)

        let expectation = self.expectation(description: "Fetch and process transactions")

        // When
        viewModel.fetchTransactions()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(self.viewModel.transactions, mockTransactions)
        }
    }
    
    func testRefreshTransactionsSuccessfully() {
        // Given
        let transactionsURL = "https://api.tzkt.io/v1/operations/transactions?level=\(testBlock.level)&offset=0&limit=10"
        let mockTransactions = [Transaction(sender: Account(alias: "account1", address: "address1"), target: Account(alias: "account2", address: "address2"), amount: 10, status: "accepted", id: 1), Transaction(sender: Account(alias: "account3", address: "address3"), target: Account(alias: "account4", address: "address4"), amount: 10, status: "accepted", id: 2)]
        let mockTransactionsData = try? JSONEncoder().encode(mockTransactions)
        mockAPIService.mockResponses[transactionsURL] = (mockTransactionsData, nil)

        let expectation = self.expectation(description: "Fetch transactions")

        // When
        viewModel.fetchTransactions()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { [self] _ in
            XCTAssertEqual(self.viewModel.transactions, mockTransactions)
            
            // Given
            var newMockTransactions = [Transaction(sender: Account(alias: "account5", address: "address5"), target: Account(alias: "account6", address: "address6"), amount: 10, status: "accepted", id: 1), Transaction(sender: Account(alias: "account7", address: "address7"), target: Account(alias: "account8", address: "address8"), amount: 10, status: "accepted", id: 2)]
            newMockTransactions.append(contentsOf: mockTransactions)
            
            let newMockTransactionsData = try? JSONEncoder().encode(newMockTransactions)
            mockAPIService.mockResponses[transactionsURL] = (newMockTransactionsData, nil)

            let newExpectation = self.expectation(description: "Fetch newly added transactions")

            // When
            viewModel.refreshTransactions()

            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                newExpectation.fulfill()
            }

            waitForExpectations(timeout: 1) { _ in
                XCTAssertEqual(self.viewModel.transactions, newMockTransactions)
                XCTAssertEqual(self.viewModel.offset, self.viewModel.limit)
            }
        }
    }

    func testFetchTransactionsFailure() {
        // Given
        let transactionsURL = "https://transactions.com"
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        mockAPIService.mockResponses[transactionsURL] = (nil, error)

        let expectation = self.expectation(description: "Fetch transactions failure")

        // When
        viewModel.fetchTransactions()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(self.viewModel.transactions.isEmpty)
        }
    }

    func testProcessFetchedTransactionsWithEmptyArray() {
        // Given
        let emptyTransactions: [Transaction] = []

        // When
        viewModel.processFetchedTransactions(emptyTransactions)

        // Then
        XCTAssertTrue(viewModel.transactions.isEmpty)
    }

    // Test offset handling when duplicate transactions are fetched
    func testOffsetHandlingWithDuplicateTransactions() {
        // Given
        let mockTransactions = [Transaction(sender: Account(alias: "account1", address: "address1"), target: Account(alias: "account2", address: "address2"), amount: 10, status: "accepted", id: 1)]
        viewModel.transactions = mockTransactions // Assume initial set of transactions
        let urlString = "https://api.tzkt.io/v1/operations/transactions?level=\(testBlock.level)&offset=\(viewModel.offset)&limit=\(viewModel.limit)"
        mockAPIService.mockResponses[urlString] = (try? JSONEncoder().encode(mockTransactions), nil)

        // When
        viewModel.fetchTransactions()

        // Then
        XCTAssertEqual(viewModel.offset, 1) // Assuming offset is updated as per number of duplicates
    }
}
