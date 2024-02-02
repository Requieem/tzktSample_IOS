//
//  CustomJsonDecoder.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

/// A utility class to provide a reusable JSONDecoder.
/// This class follows the Singleton pattern.
class CustomJsonDecoder {
    
    /// Shared instance of DateFormatterManager.
    static let shared = CustomJsonDecoder()

    /// Private init to prevent instantiation from outside.
    private init() {}

    /// A DateFormatter configured for long dates and no time
    lazy var tzktJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

// Example of how to use:
// let formattedDate = CustomDateFormatter.shared.blockJsonFormatter.string(from: someDate)
