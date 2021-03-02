//
//  BaseTest.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {

    let app = XCUIApplication()
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func deleteApp() {
        app.terminate()
        let icon = springboard.icons["OrderMe"]
        icon.press(forDuration: 1.3)
        let removeAppButton = springboard.buttons["Remove App"]
        removeAppButton.tap()
        let deleteAppButton = springboard.buttons["Delete App"]
        deleteAppButton.tap()
        let deleteButton = springboard.buttons["Delete"]
        deleteButton.tap()
    }
}
