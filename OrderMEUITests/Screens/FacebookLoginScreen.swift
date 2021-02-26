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
    private let continueButton: XCUIElement = app.buttons["Continue"]

    required init() {
        super.init()
        visible()
    }
    
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
    public func login() -> RestaurantsListScreen {
        loginButton.tap()
        continueButton.waitForExistence(timeout: 5)
        continueButton.tap()
        return RestaurantsListScreen()
    }
}

extension FacebookLoginScreen {
    func visible() {
        guard loginButton.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Facebook login screen is not present")
            return
        }
    }
}
