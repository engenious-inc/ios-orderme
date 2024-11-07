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
}

// MARK: - Activities
extension LoginScreen {
    @discardableResult
    func loginLater()-> Self {
        loginLaterButton.element.tap()
        return self
    }
}
