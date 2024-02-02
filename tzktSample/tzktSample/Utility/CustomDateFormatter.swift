//
//  CustomDateFormatter.swift
//  tzktSample
//
//  Created by Marco Farace on 01.02.24.
//

import Foundation

/// A utility class to provide a reusable DateFormatter.
/// This class follows the Singleton pattern.
class CustomDateFormatter {
    
    /// Shared instance of DateFormatterManager.
    static let shared = CustomDateFormatter()

    /// Private init to prevent instantiation from outside.
    private init() {}

    /// A DateFormatter configured for long dates and no time
    lazy var blockDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

// Example of how to use:
// let formattedDate = CustomDateFormatter.shared.blockDateFormatter.string(from: someDate)
