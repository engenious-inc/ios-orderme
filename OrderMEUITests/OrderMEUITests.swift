//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/9/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: BaseTest {

    func testBringAMenu() throws {
        let app = XCUIApplication()
        app.launch()

        let loginLaterButton = app.buttons["loginLaterButton"]
        loginLaterButton.tap()

        let republiqueRest = app.staticTexts["Republique"]
        republiqueRest.tap()

        let detectTableOption = app.collectionViews.staticTexts["Detect table"]
        detectTableOption.tap()

        let tableNumberField = app.textFields["tableNumberTextField"]
        tableNumberField.tap()
        tableNumberField.typeText("3")
        let selectTableButton = app.buttons["Select table"]
        selectTableButton.tap()

        let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]
        callAWaiterOption.tap()

        let waiterAlert = app.alerts["The waiter is on his way"]
        let bringAMenuButton = waiterAlert.buttons["Bring a menu"]
        bringAMenuButton.tap()

        let gotItAlert = app.alerts["Got it!"]
        XCTAssert(gotItAlert.waitForExistence(timeout: 2), "Got it alert is not present")
    }

    func testCallRestaurant() throws {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .callRestaurant)

        XCTAssert(restaurantScreen.callAlert.waitForExistence(timeout: 2),
                  "Call alert is not present")
    }

    func testVerifyMyReservationsTabIsRestricted() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()
        let myReservationsScreen = restaurantsListScreen.tapMyReservations()

        XCTAssert(myReservationsScreen.youDidNotLoginAlert.waitForExistence(timeout: 2),
                  "You did not login alert is not present")
    }

    func testVerifyBackNavigationFromRestaurantScreen() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater()
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.backTo(screen: RestaurantsListScreen.self)
    }

    func testLoginWithFacebook() {
        let loginScreen = LoginScreen()
        let facebookLoginScreen = loginScreen.loginWithFacebook()
        if !facebookLoginScreen.isContinueWithFacebookButtonVisible() {
            facebookLoginScreen.typeEmail("zkpedymhza_1614299001@tfbnw.net")
                                                       .typePassword("orderme12345")
                                                       .login()
                                                       .continueWithFacebook()
        } else {
            facebookLoginScreen.continueWithFacebook()
        }
        deleteApp()
    }
}
