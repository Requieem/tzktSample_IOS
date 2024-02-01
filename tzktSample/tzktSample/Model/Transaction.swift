//
//  Transaction.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import Foundation

struct Transaction : Codable, Equatable
{
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id == rhs.id
    }
    
    let sender : Account
    let target : Account
    let amount : Int
    let status : String
    let id : Int
}
