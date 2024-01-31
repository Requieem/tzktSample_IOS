//
//  VM_BlockTable.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import Foundation
import Combine

class VM_BlockTable : ObservableObject {
    @Published var blocks = [Block]()
    
    var offset : Int = 0
    let limit : Int = 10

    func fetchBlocks() {
        let urlString = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=\(offset)&limit=\(limit)"
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
                var newBlocks = try decoder.decode([Block].self, from: data)

                let group = DispatchGroup()
                
                var actuallyNewBlocks = newBlocks.filter { block in
                    !strongSelf.blocks.contains(where: { $0 == block })
                }
                
                strongSelf.offset += newBlocks.count - actuallyNewBlocks.count
                
                for (index, block) in actuallyNewBlocks.enumerated() {
                    group.enter()
                    strongSelf.fetchTransactionCount(for: block.level) { count in
                        DispatchQueue.main.async {
                            actuallyNewBlocks[index].transactionCount = count
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) { [] in
                    strongSelf.blocks.append(contentsOf: actuallyNewBlocks)
                    strongSelf.offset += strongSelf.limit
                    print("OFFSET: \(strongSelf.offset)")
                    print("LIMIT: \(strongSelf.limit)")
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }

        task.resume()
    }
    
    func fetchPagedBlocks(completion: @escaping ([Block]) -> Void) {
        let urlString = "https://api.tzkt.io/v1/blocks?sort.desc=level&offset=\(offset)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                completion([])
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newBlocks = try decoder.decode([Block].self, from: data)
                completion(newBlocks)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion([])
            }
        }

        task.resume()
    }
    
    private func fetchTransactionCount(for level: Int, completion: @escaping (Int) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.tzkt.io/v1/operations/transactions/count?level=\(level)")!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }

            do {
                // Assuming the response is just an integer
                let transactionCount = try JSONDecoder().decode(Int.self, from: data)
                DispatchQueue.main.async {
                    completion(transactionCount)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }

        task.resume()
    }
}
