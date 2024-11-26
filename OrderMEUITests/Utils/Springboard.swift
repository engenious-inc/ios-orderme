//
//  Springboard.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 26/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

enum Springboard {
    static let shared: XCUIApplication = .init(bundleIdentifier: "com.apple.springboard")

    static func deleteApp() {
        guard shared.icons["OrderMe"].exists else {
            return
        }
        shared.icons["OrderMe"].firstMatch.press(forDuration: 2.0)
        shared.buttons["Remove App"].firstMatch.tap()
        shared.buttons["Delete App"].firstMatch.tap()
        shared.buttons["Delete"].firstMatch.tap()
    }
}
