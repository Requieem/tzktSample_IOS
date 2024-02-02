//
//  MockDecodable.swift
//  tzktSampleTests
//
//  Created by Marco Farace on 02.02.24.
//

import Foundation

// A mock decodable to test decoding error
struct MockDecodable: Decodable, Equatable {
    let id: Int
}
