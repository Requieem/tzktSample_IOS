//
//  TransactionTable.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import SwiftUI

struct TransactionTable: View {
    @StateObject var viewModel : VM_TransactionTable
    
    init(block : Block) {
        _viewModel = StateObject(wrappedValue: VM_TransactionTable(block: block))
    }
    
    var body: some View {
        VStack {
            ZStack {
                UnevenRoundedRectangle(cornerRadii:     RectangleCornerRadii(bottomLeading: 25, bottomTrailing: 25))
                    .fill(Color.accentColor)
                    .frame(height: 170)
                VStack
                {
                    Text("Powered by")
                        .foregroundColor(.white)
                    HStack {
                        Image(systemName: "t.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Image(systemName: "z.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Image(systemName: "k.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                        Image(systemName: "t.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white, lineWidth: 3)
                    )
                }
                .offset(CGSize(width: 0.0, height: 20.0))
            }
            List(viewModel.transactions, id: \.id) { transaction in
                transactionRow(transaction)
                    .onAppear {
                        if transaction == viewModel.transactions.last {
                            withAnimation {
                                viewModel.fetchTransactions()
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
            }
            .onAppear {
                viewModel.fetchTransactions()
            }
            .zIndex(-1)
            .padding(-15)
            .animation(.easeIn, value: viewModel.transactions)
            .scrollContentBackground(.hidden)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    
    @ViewBuilder
    private func transactionRow(_ transaction: Transaction) -> some View {
        VStack {
            VStack {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii:     RectangleCornerRadii(topLeading: 15, topTrailing: 15))
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
                    UnevenRoundedRectangle(cornerRadii:     RectangleCornerRadii(bottomLeading: 15, bottomTrailing: 15))
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

struct TransactionTable_Previews: PreviewProvider {
    static func block() -> Block {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let jsonString = """
        {"cycle":699,"level":5020940,"hash":"BLBteK4t7rkeDdvs1Ae99j2i4KW4eTTGDHGQQ9XitRXfP5nX77h","timestamp":"2024-01-31T17:10:00Z","proto":17,"payloadRound":0,"blockRound":0,"validations":6998,"deposit":0,"reward":5000000,"bonus":4995333,"fees":21437,"nonceRevealed":false,"proposer":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"producer":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"software":{"date":"2023-06-07T15:27:29Z"},"lbToggleEma":416078956,"priority":0,"baker":{"alias":"CoinbaseBaker","address":"tz1irJKkXS2DBWkU1NnmFQx1c1L7pbGg4yhk"},"lbEscapeVote":false,"lbEscapeEma":416078956}
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Invalid JSON string")
        }
        var block : Block = Block.init(level: 0, timestamp: Date.now, proposer: Account.init(alias: "", address: ""))
        do {
            block = try decoder.decode(Block.self, from: jsonData)
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

