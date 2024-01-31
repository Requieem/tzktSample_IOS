import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = VM_BlockTable()

    var body: some View {
        VStack {
            Image(systemName: "t.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Spacer()
            // Blocks Table
            List(viewModel.blocks, id: \.level) { block in
                blockRow(block)
                    .onAppear {
                        if block == viewModel.blocks.last {
                            withAnimation {
                                viewModel.fetchBlocks()
                            }
                        }
                    }
            }
            .onAppear {
                viewModel.fetchBlocks()
            }
            .animation(.easeIn, value: viewModel.blocks)
            
            Spacer()
            Text("TZKT Mobile Explorer!")
        }
        .padding()
    }
    
    @ViewBuilder
    private func blockRow(_ block: Block) -> some View {
        VStack {
            Text("Block Level: \(block.level)")
            Spacer()
            HStack {
                Text("Account: ")
                Text(block.proposer.alias ?? "Unknown")
                Text(block.proposer.address)
            }
            Text("\(block.transactionCount ?? 0)")
            Text(block.timestamp, style: .date)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
