//
//  Block.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import Foundation

struct Block : Codable, Equatable
{
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.level == rhs.level
    }
    
    let level : Int
    let timestamp : Date
    let proposer : Account
    var transactionCount : Int?
}
