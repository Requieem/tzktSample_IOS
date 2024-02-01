//
//  tzktSampleApp.swift
//  tzktSample
//
//  Created by Marco Farace on 31.01.24.
//

import SwiftUI

@main
struct tzktSampleApp: App {
    var body: some Scene {
        WindowGroup {
            BlockTable()
                .environment(\.font, .custom("Urbanist", size: 12))
        }
    }
}
