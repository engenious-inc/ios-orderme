//
//  FacebookLoginScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 26/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class FacebookLoginScreen: BaseScreen {
    private lazy var emailTextField: TextField = element.textFields.firstMatch.build()
    private lazy var passwordTextField: SecureTextField = element.secureTextFields.firstMatch.build()
    private lazy var loginButton: Button = element.buttons["Log in"].build()
    private lazy var continueWithFacebookButton: Button = element.buttons["Continue as Tom"].build()
}

// MARK: - Activities
extension FacebookLoginScreen {
    @discardableResult
    func typeEmail(_ email: String) -> Self {
        emailTextField.tap()
        emailTextField.type(email)
        return self
    }

    @discardableResult
    func typePassword(_ password: String) -> Self {
        passwordTextField.tap()
        passwordTextField.type(password)
        return self
    }

    @discardableResult
    func login() -> Self {
        loginButton.tap()
        return self
    }

    @discardableResult
    func continueWithFacebook() -> Self {
        if isContinueWithFacebookButtonVisible() {
            continueWithFacebookButton.tap()
        } else {
            XCTFail("Continue with Facebook button is not visible")
        }
        return self
    }

    private func isContinueWithFacebookButtonVisible() -> Bool {
        return continueWithFacebookButton.element.waitForExistence(timeout: defaultTimeout)
    }
}
