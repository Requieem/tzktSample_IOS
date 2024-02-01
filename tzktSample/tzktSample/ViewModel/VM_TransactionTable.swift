//
//  VM_TransactionTable.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

class VM_TransactionTable : ObservableObject {
    @Published var transactions = [Transaction]()
    private var block: Block

    init(block: Block) {
        self.block = block
    }
    
    var offset : Int = 0
    let limit : Int = 10

    func fetchTransactions() {
        let urlString = "https://api.tzkt.io/v1/operations/transactions?level=\(block.level)&offset=\(offset)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [strongSelf = self] data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                var newTransactions = try decoder.decode([Transaction].self, from: data)

                let group = DispatchGroup()
                
                let oldCount = newTransactions.count
                newTransactions = newTransactions.filter { transaction in
                    !strongSelf.transactions.contains(where: { $0 == transaction })
                }
                
                strongSelf.offset += oldCount - newTransactions.count

                group.notify(queue: .main) { [] in
                    strongSelf.transactions.append(contentsOf: newTransactions)
                    strongSelf.offset += strongSelf.limit
                }
            } catch {
                print("Failed to decode Transaction JSON: \(error)")
            }
        }

        task.resume()
    }
}
