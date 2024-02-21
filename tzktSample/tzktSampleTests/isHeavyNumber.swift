//
//  isHeavyNumber.swift
//  tzktSample
//
//  Created by Marco Farace on 21.02.24.
//

import Foundation

func isHeavyNumber(value: UInt) -> Bool {
    func numToDigit(of num: UInt) -> UInt {
        var sum = num
        while sum >= 10 {
            sum = digitSum(sum)
        }
        
        return sum
    }
    
    func digitSum(_ num: UInt) -> UInt {
        var sum = 0
        var n = num
        while n > 0 {
            sum += Int(n % 10)
            n /= 10
        }
        return UInt(sum)
    }
    
    let resultDigit = numToDigit(of: value)
    return resultDigit > 7
 }
