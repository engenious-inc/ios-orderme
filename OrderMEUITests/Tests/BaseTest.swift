//
//  BaseTest.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest
import SBTUITestTunnelClient

class BaseTest: XCTestCase {

    static var shared: BaseTest!

    override func setUpWithError() throws {
        BaseTest.shared = self
        continueAfterFailure = false
        XCTContext.runActivity(named: "Given I have launched app in clean state") { _ in
            app.launchArguments = ["startStubServer", "logOut"]
//            app.launchTunnel()
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
