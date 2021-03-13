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

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCTContext.runActivity(named: "Given I have launched app in clean state") { _ in
            app.launchArguments = ["logOut"]
            app.launch()
        }
    }

    func deleteApp() {
        app.terminate()
        let icon = BaseScreen.springboard.icons["OrderMe"]
        icon.press(forDuration: 1.3)
        let removeAppButton = BaseScreen.springboard.buttons["Remove App"]
        removeAppButton.tap()
        let deleteAppButton = BaseScreen.springboard.buttons["Delete App"]
        deleteAppButton.tap()
        let deleteButton = BaseScreen.springboard.buttons["Delete"]
        deleteButton.tap()
    }
}
