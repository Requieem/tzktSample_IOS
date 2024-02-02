//
//  VM_BlockTable.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import Foundation

/// ViewModel for managing and fetching blockchain blocks for `BlockTable` view.
class VM_BlockTable: ObservableObject {
    @Published var blocks = [Block]()
    @Published var lastError: Error?
    
    var offset: Int = 0
    let limit: Int = 10
    private var apiService: APIService
    
    /// Initializes the ViewModel with a specific apiService.
    /// - Parameter apiService: The apiService to inject for request handling
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    /// Fetches blocks from the server and updates the `blocks` array.
    func fetchBlocks() {
        let urlString = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=\(offset)&limit=\(limit)"
        apiService.fetch(urlString, decodingType: [Block].self) { [weak self] result in
            switch result {
            case .success(let newBlocks):
                self?.processFetchedBlocks(newBlocks)
            case .failure(let error):
                self?.lastError = error
                print("Error fetching blocks: \(error.localizedDescription)")
            }
        }
    }
    
    /// Processes the blocks fetched from the server.
    /// It filters out duplicate blocks and fetches transaction counts for new blocks.
    func processFetchedBlocks(_ newBlocks: [Block]) {
        let actuallyNewBlocks = newBlocks.filter { !self.blocks.contains($0) }
        self.offset += newBlocks.count - actuallyNewBlocks.count
        
        let group = DispatchGroup()
        var updatedBlocks = actuallyNewBlocks
        
        for (index, block) in actuallyNewBlocks.enumerated() {
            group.enter()
            fetchTransactionCount(for: block.level) { count in
                updatedBlocks[index].transactionCount = count
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.blocks.append(contentsOf: updatedBlocks)
            self.offset += self.limit
        }
    }
    
    /// Fetches the transaction count for a given block level.
    /// - Parameters:
    ///   - level: The block level.
    ///   - completion: Closure called with the transaction count.
    func fetchTransactionCount(for level: Int, completion: @escaping (Int) -> Void) {
        let urlString = "https://api.tzkt.io/v1/operations/transactions/count?level=\(level)"
        apiService.fetch(urlString, decodingType: Int.self) { result in
            switch result {
            case .success(let count):
                completion(count)
            case .failure(let error):
                self.lastError = error
                completion(-1)
                print("Error fetching transaction count: \(error.localizedDescription)")
            }
        }
    }
}
