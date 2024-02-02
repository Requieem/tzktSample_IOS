//
//  TransactionTable.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import SwiftUI

/// `TransactionTable` displays a list of transactions for a given block.
/// It adapts its appearance based on the device's color scheme.
struct TransactionTable: View {
    @StateObject var viewModel: VM_TransactionTable
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// Initializes the view with a specific block.
    /// - Parameter block: The block for which transactions are displayed.
    init(block: Block) {
        _viewModel = StateObject(wrappedValue: VM_TransactionTable(block: block))
    }
    
    var body: some View {
        VStack {
            List(viewModel.transactions, id: \.id) { transaction in
                transactionRow(transaction)
                    .onAppear {
                        // Fetch more transactions when the last one becomes visible
                        if transaction == viewModel.transactions.last {
                            withAnimation {
                                viewModel.fetchTransactions()
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            }
            .onAppear {
                // Initial data fetching
                viewModel.fetchTransactions()
            }
            .zIndex(-1)
            .padding(-15)
            .animation(.easeIn, value: viewModel.transactions)
            .scrollContentBackground(.hidden)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.white))
    }
    
    /// Creates a row view for each transaction in the list.
    /// - Parameter transaction: The transaction data to display.
    /// - Returns: A view representing a single transaction row.
    @ViewBuilder
    private func transactionRow(_ transaction: Transaction) -> some View {
        VStack {
            VStack {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 15, topTrailing: 15))
                        .fill(Color.accentColor)
                    HStack {
                        HStack {
                            Text("\(transaction.id)")
                                .fontWeight(.bold)
                            Text("\(transaction.status)")
                        }
                        Spacer()
                        HStack {
                            Text("Amount:")
                                .fontWeight(.bold)
                            Text("\(transaction.amount)")
                        }
                    }
                    .frame(alignment: .trailingLastTextBaseline)
                    .foregroundColor(.white)
                    .padding(12.5)
                }
                .frame(height: 32)
                
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 15, bottomTrailing: 15))
                        .stroke(Color.accentColor, lineWidth: 2)
                    VStack {
                        HStack {
                            Text("From:")
                                .fontWeight(.light)
                            Text("\(transaction.sender.address)")
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("To:")
                                .fontWeight(.light)
                            Text("\(transaction.target.address)")
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .frame(height: 58)
            }
            .shadow(radius: 5)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.accentColor, lineWidth: 3)
            )
        }
        .font(.custom("Urbanist", size: 13))
    }
}

/// Preview provider for `BlockTable`.
struct TransactionTable_Previews: PreviewProvider {
    static func block() -> Block {
        // Response copied from Postman
        let jsonString = """
        {"cycle":699,"level":5020940,"hash":"BLBteK4t7rkeDdvs1Ae99j2i4KW4eTTGDHGQQ9XitRXfP5nX77h","timestamp":"2024-01-31T17:10:00Z","proto":17,"payloadRound":0,"blockRound":0,"validations":6998,"deposit":0,"reward":5000000,"bonus":4995333,"fees":21437,"nonceRevealed":false,"proposer":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"producer":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"software":{"date":"2023-06-07T15:27:29Z"},"lbToggleEma":416078956,"priority":0,"baker":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"lbEscapeVote":false,"lbEscapeEma":416078956}
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Invalid JSON string")
        }
        var block : Block = Block.init(level: 0, timestamp: Date.now, proposer: Account.init(alias: "", address: ""))
        do {
            block = try CustomJsonDecoder.shared.tzktJsonDecoder.decode(Block.self, from: jsonData)
        } catch {
            print("Failed to decode Block JSON: \(error)")
        }
        
        return block
    }
    
    static var previews: some View {
        let block : Block = block()
        TransactionTable(block: block)
    }
}

