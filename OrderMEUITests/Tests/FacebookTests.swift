//
//  FacebookTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 26/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class FacebookTests: BaseTest {
    override func tearDown() {
        Springboard.deleteApp()
        super.tearDown()
    }

    func testLoginWithFacebook() {
        LoginScreen()
            .loginWithFacebook()
        if !FacebookLoginScreen().isContinueWithFacebookButtonVisible() {
            FacebookLoginScreen()
            .typeEmail("zkpedymhza_1614299001@tfbnw.net")
            .typePassword("orderme12345")
            .login()
            .continueWithFacebook()
        } else {
            FacebookLoginScreen().continueWithFacebook()
        }
    }
}
