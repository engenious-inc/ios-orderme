//
//  LoginScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class LoginScreen: BaseScreen {
    private lazy var loginLaterButton: Button = element.buttons["loginLaterButton"].build()
    private lazy var facebookButton: Button = element.buttons["facebookLoginButton"].build()
    private lazy var continueWithFacebookSpringAlert: Alert = Springboard.shared.alerts.buttons["Continue"].build()
}

// MARK: - Activities
extension LoginScreen {
    @discardableResult
    func loginLater(stub: PlacesStub? = nil) -> Self {
        stub?.start()
        loginLaterButton.tap()
        return self
    }

    @discardableResult
    func loginWithFacebook()-> Self {
        facebookButton.tap()
        if continueWithFacebookSpringAlert.element.waitForExistence(timeout: defaultTimeout) {
            continueWithFacebookSpringAlert.tap()
        }
        return self
    }
}
