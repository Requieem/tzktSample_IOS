//
//  BlockTable.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import SwiftUI

struct BlockTable: View {
    @StateObject var viewModel = VM_BlockTable()
    
    var body: some View {
            VStack {
                NavigationView{
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
                        List(viewModel.blocks, id: \.level) { block in
                            blockRow(block)
                                .onAppear {
                                    if block == viewModel.blocks.last {
                                        withAnimation {
                                            viewModel.fetchBlocks()
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        }
                        .onAppear {
                            viewModel.fetchBlocks()
                        }
                        .zIndex(-1)
                        .padding(-15)
                        .animation(.easeIn, value: viewModel.blocks)
                        .scrollContentBackground(.hidden)
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            }
    }
    
    
    @ViewBuilder
    private func blockRow(_ block: Block) -> some View {
        var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: block.timestamp)
        }
        VStack {
            ZStack {
                NavigationLink(destination: TransactionTable(block: block)) {
                }
                .opacity(0.0)
                VStack {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii:     RectangleCornerRadii(topLeading: 15, topTrailing: 15))
                            .fill(Color.accentColor)
                        HStack {
                            HStack {
                                Text("Block Level:")
                                    .fontWeight(.bold)
                                Text("\(block.level)")
                            }
                            Spacer()
                            Text(formattedDate)
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
                                Text("Proposed By:")
                                    .fontWeight(.light)
                                Text("\(block.proposer.alias ?? "Unknown")")
                                    .fontWeight(.bold)
                            }
                            Text("\(block.proposer.address)")
                                .foregroundColor(Color.accentColor)
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
            
            
            Text("# of Transactions: \(block.transactionCount ?? 0)")
        }
        .font(.custom("Urbanist", size: 13))
    }
}

struct BlockTable_Previews: PreviewProvider {
    static var previews: some View {
        BlockTable()
    }
}
