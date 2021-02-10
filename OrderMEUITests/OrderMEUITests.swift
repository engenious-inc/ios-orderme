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

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Login Later"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText,
                                     identifier: "12229 Ventura Blvd, Studio City, CA").element.swipeUp()
        tablesQuery.staticTexts["Republique"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["Detect table"].tap()
        app.textFields["tableNumberTextField"].tap()
        app.buttons["Select table"].tap()
        collectionViewsQuery.staticTexts["Call a waiter"].tap()
        app.alerts["The waiter is on his way"].scrollViews.otherElements.buttons["Bring a menu"].tap()
        app.alerts["Got it!"].scrollViews.otherElements.buttons["OK"].tap()
        
    }
}
