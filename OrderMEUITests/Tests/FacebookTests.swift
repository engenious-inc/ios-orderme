//
//  FacebookTests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/9/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class FacebookTests: BaseTest {

    override func setUp() {
        super.setUp()
        app.launchTunnel()
    }

    override func tearDown() {
        deleteApp()
        super.tearDown()
    }

    func testLoginWithFacebook() {
        let loginScreen = LoginScreen()
        let facebookScreen = loginScreen.loginWithFacebook()
        if !facebookScreen.isContinueWithFacebookButtonVisible() {
            facebookScreen
                .typeEmail("zkpedymhza_1614299001@tfbnw.net")
                .typePassword("orderme12345")
                .login()
                .continueWithFacebook()
        } else {
            facebookScreen.continueWithFacebook()
        }
    }
}
