//
//  Header.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import SwiftUI

/// `Header` is a view component that displays a custom header.
/// It features a unique design with rounded corners and branded imagery.
struct Header: View {
    var body: some View {
        ZStack {
            // Background shape with uneven rounded corners
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 25, bottomTrailing: 25))
                .fill(Color.accentColor)
                .ignoresSafeArea()
                .frame(height: 150)

            VStack {
                // Text label
                Text("Powered by")
                    .foregroundColor(.white)

                // Horizontal stack of images
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
                .padding(15)
                .overlay(
                    // Rounded rectangle border around images
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white, lineWidth: 3)
                        .shadow(color: Color(UIColor.black), radius: 5)
                )
            }
        }
    }
}
