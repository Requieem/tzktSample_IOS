//
//  Transaction.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import Foundation

struct Transaction : Codable
{
    let sender : Account
    let receiver : Account
    let amount : Int
    let status : String
}
