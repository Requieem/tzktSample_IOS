//
//  VM_TransactionTable.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

/// ViewModel for managing and fetching transactions for a specific block.
class VM_TransactionTable: ObservableObject {
    @Published var transactions = [Transaction]()
    
    var offset: Int = 0
    var limit: Int = 10
    private var block: Block
    private var apiService: APIService

    /// Initializes the ViewModel with a specific block and apiService.
    /// - Parameter block: The block for which transactions are fetched.
    /// - Parameter apiService: The apiService to inject for request handling
    init(block: Block, apiService: APIService = APIService()) {
        self.apiService = apiService
        self.block = block
    }

    /// Fetches transactions associated with the block from the server.
    func fetchTransactions() {
        let urlString = "https://api.tzkt.io/v1/operations/transactions?level=\(block.level)&offset=\(offset)&limit=\(limit)"
        apiService.fetch(urlString, decodingType: [Transaction].self) { [weak self] result in
            switch result {
            case .success(let newTransactions):
                self?.processFetchedTransactions(newTransactions)
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    /// Refreshes the transactions list by erasing it and initializing the offset
    func refreshTransactions() {
        self.transactions = []
        self.offset = 0
        self.fetchTransactions()
    }

    /// Processes the transactions fetched from the server.
    /// Filters out duplicates and appends new transactions to the published array.
    func processFetchedTransactions(_ newTransactions: [Transaction]) {
        let filteredTransactions = newTransactions.filter { !self.transactions.contains($0) }
        let fetchedCount = newTransactions.count - filteredTransactions.count
        self.offset += fetchedCount
        
        DispatchQueue.main.async {
            self.transactions.append(contentsOf: filteredTransactions)
            self.offset += self.limit
        }
    }
}
