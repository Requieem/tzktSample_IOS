//
//  BlockTable.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import SwiftUI

/// `BlockTable` displays a list of blockchain blocks using a ViewModel.
/// It adapts its appearance based on the device's color scheme.
struct BlockTable: View {
    @StateObject var viewModel = VM_BlockTable()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
            NavigationView {
                List(viewModel.blocks, id: \.level) { block in
                    blockRow(block)
                        .onAppear {
                            // Fetch more blocks when the last one becomes visible
                            if block == viewModel.blocks.last {
                                withAnimation(.easeIn) {
                                    viewModel.fetchBlocks()
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                }
                .onAppear {
                    // Initial data fetching
                    viewModel.fetchBlocks()
                }
                .listStyle(.grouped)
                .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.white))
                .scrollContentBackground(.hidden)
            }
        }
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.white))
    }
    
    /// Creates a row view for each block in the list.
    /// - Parameter block: The block data to display.
    /// - Returns: A view representing a single block row.
    @ViewBuilder
    private func blockRow(_ block: Block) -> some View {
        let formattedDate = CustomDateFormatter.shared.blockDateFormatter.string(from: block.timestamp)
        VStack {
            ZStack {
                NavigationLink(destination: TransactionTable(block: block)) {}
                .opacity(0.0)
                VStack {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 15, topTrailing: 15))
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
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 15, bottomTrailing: 15))
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

/// Preview provider for `BlockTable`.
struct BlockTable_Previews: PreviewProvider {
    static var previews: some View {
        BlockTable()
    }
}
