//
//  FacebookLoginScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/8/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class FacebookLoginScreen: BaseScreen {
    private lazy var emailTextField: XCUIElement = app.textFields.firstMatch
    private lazy var passwordTextField: XCUIElement = app.secureTextFields.firstMatch
    private lazy var loginButton: XCUIElement = app.buttons["Log In"]
    private lazy var continueWithFacebookButton: XCUIElement = app.buttons["Continue"]

    @discardableResult
    public func typeEmail(_ email: String) -> Self {
        tap(emailTextField)
        type(email, element: emailTextField)
        return self
    }

    @discardableResult
    public func typePassword(_ password: String) -> Self {
        tap(passwordTextField)
        type(password, element: passwordTextField)
        return self
    }

    @discardableResult
    public func login() -> Self {
        tap(loginButton)
        return self
    }

    @discardableResult
    public func continueWithFacebook() -> RestaurantsListScreen {
        if isContinueWithFacebookButtonVisible() {
            tap(continueWithFacebookButton)
        } else {
            XCTFail("Continue with Facebook button is not visible")
        }
        return RestaurantsListScreen()
    }

    func isContinueWithFacebookButtonVisible() -> Bool {
        return continueWithFacebookButton.waitForExistence(timeout: visibleTimeout)
    }
}