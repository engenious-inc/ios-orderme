//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/9/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testBringAMenu() throws {
        let app = XCUIApplication()
        app.launch()

        let loginLaterButton = app.buttons["loginLaterButton"]
        loginLaterButton.tap()

        let republiqueRest = app.staticTexts["Republique"]
        republiqueRest.tap()

        let detectTableOption = app.collectionViews.staticTexts["Detect table"]
        detectTableOption.tap()

        let tableNumberField = app.textFields["tableNumberTextField"]
        tableNumberField.tap()
        tableNumberField.typeText("3")
        let selectTableButton = app.buttons["Select table"]
        selectTableButton.tap()

        let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
        callAWaiterOption.tap()

        let waiterAlert = app.alerts["The waiter is on his way"]
        let bringAMenuButton = waiterAlert.buttons["Bring a menu"]
        bringAMenuButton.tap()

        let gotItAlert = app.alerts["Got it!"]
        XCTAssert(gotItAlert.waitForExistence(timeout: 2), "Got it alert is not present")
    }
}
