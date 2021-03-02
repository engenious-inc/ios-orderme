//
//  FacebookLoginScreen.swift
//  OrderMEUITests
//
//  Created by Leonid Hurtovyi on 25.02.2021.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class FacebookLoginScreen: BaseScreen {
    private let emailTextField: XCUIElement = app.textFields.firstMatch
    private let passwordTextFielld: XCUIElement = app.secureTextFields.firstMatch
    private let loginButton: XCUIElement = app.buttons["Log In"]
    private let continueWithFacebookButton: XCUIElement = app.buttons["Continue"]
    private let loginWithFacebookLabel: XCUIElement = app.staticTexts["Log in With Facebook"]

    @discardableResult
    public func typeEmail(_ email: String) -> Self {
        emailTextField.tap()
        emailTextField.typeText(email)
        return self
    }

    @discardableResult
    public func typePassword(_ password: String) -> Self {
        passwordTextFielld.tap()
        passwordTextFielld.typeText(password)
        return self
    }

    @discardableResult
    public func login() -> Self {
        loginButton.tap()
        return self
    }

    @discardableResult
    public func continueWithFacebook() -> RestaurantsListScreen {
        if isContinueWithFacebookButtonVisible() {
            continueWithFacebookButton.tap()
        } else {
            XCTFail("Continue with facebook button is not present")
        }
        return RestaurantsListScreen()
    }
}

extension FacebookLoginScreen {
    func isContinueWithFacebookButtonVisible() -> Bool {
        return continueWithFacebookButton.waitForExistence(timeout: visibleTimeout)
    }
}
