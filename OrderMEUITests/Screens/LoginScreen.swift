//
//  LoginScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class LoginScreen: BaseScreen {
    private let loginLaterButton: XCUIElement = app.buttons["loginLaterButton"]
    private let facebookLoginButton: XCUIElement = app.buttons["facebookLoginButton"]
    private let continueWithFacebookAlert: XCUIElement = springboard.alerts.firstMatch.buttons["Continue"]

    required init() {
        super.init()
        visible()
    }

    public func loginLater() -> RestaurantsListScreen {
        loginLaterButton.tap()
        return RestaurantsListScreen()
    }

    public func loginWithFacebook() -> FacebookLoginScreen {
        facebookLoginButton.tap()
        continueWithFacebookAlert.waitForExistence(timeout: 5)
        continueWithFacebookAlert.tap()
        return FacebookLoginScreen()
    }
}

extension LoginScreen {
    func visible() {
        guard loginLaterButton.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Login screen is not present")
            return
        }
    }
}
