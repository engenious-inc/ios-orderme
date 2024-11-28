//
//  OrderMEUITests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/9/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class OrderMEUITests: BaseTest {
    func testBringAMenu() {
        LoginScreen()
            .loginLater()

        RestaurantsListScreen()
            .openRepubliqueRestaurant()

        RestaurantScreen()
            .choose(option: .detectTable)

        DetectTableScreen()
            .selectTable(number: 7)

        RestaurantScreen()
            .choose(option: .callAWaiter)

        WaiterScreen()
            .choose(option: .bringAMenu)
            .assertGotItAlertIsPresent()
    }

    func testCallRestaurant() {
        LoginScreen()
            .loginLater()

        RestaurantsListScreen()
            .openRepubliqueRestaurant()

        RestaurantScreen()
            .choose(option: .callRestaurant)
            .assertCallAlertIsPresent()
    }

    func testVerifyMyReservationsTabIsRestricted() {
        LoginScreen()
            .loginLater()

        RestaurantsListScreen()
            .tapMyReservations()

        MyReservationsScreen()
            .assertYouDidNotLoginAlertIsPresent()
    }

    func testVerifyBackNavigationFromRestaurantScreen() {
        LoginScreen()
            .loginLater()

        RestaurantsListScreen()
            .openRepubliqueRestaurant()

        RestaurantScreen()
            .backTo(screen: RestaurantsListScreen.self)
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

    func testChallenge() {
        let today = Date()
        guard let futureDate = today.getUIDateForTodayPlus(days: 3) else {
            XCTFail("Unable to create a future date")
            return
        }
        let day = futureDate.day
        let month = futureDate.month

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
        
        RestaurantsListScreen()
            .openHakkasanRestaurant()
        RestaurantScreen()
            .choose(option: .reservation)
        ReservationsScreen()
            .assertBookButtonIsPresent()
            .typePhoneNumber("2124567890")
            .typeNumberOfPeople("2")
            .selectDate(month: month, day: day, hour: 7, minute: 45, amPm: .pmTime)
            .reserve()
            .assertSuccessAllertExist()
            .tapOK()
            .tapMyReservations()
        MyReservationsScreen()
            .assertCurrentReservationsButtonIsSelected()
            .assertReservationInHakkasan()
    }
}
