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
    private let facebookButton: XCUIElement = app.buttons["facebookLoginButton"]
    private let continueWithFacebookSpringAlert: XCUIElement = springboard.alerts.firstMatch.buttons["Continue"]

    required init() {
        super.init()
        visible()
    }

    public func loginLater() -> RestaurantsListScreen {
        tap(loginLaterButton)
        return RestaurantsListScreen()
    }

    public func loginWithFacebook() -> FacebookLoginScreen {
        tap(facebookButton)
        if continueWithFacebookSpringAlert.waitForExistence(timeout: 0.5){
            tap(continueWithFacebookSpringAlert)
        }
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
