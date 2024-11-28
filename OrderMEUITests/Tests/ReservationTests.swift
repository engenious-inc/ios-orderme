//
//  ReservationTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 27/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class ReservationTests: BaseTest {
    func testPhoneNumberRequired() {
        let today = Date()
        guard let futureDate = today.getUIDateForTodayPlus(days: 3) else {
            XCTFail("Unable to create a future date")
            return
        }
        let day = futureDate.day
        let month = futureDate.month

        LoginScreen()
            .loginLater()
        RestaurantsListScreen()
            .openRepubliqueRestaurant()
        RestaurantScreen()
            .choose(option: .reservation)
        ReservationsScreen()
            .assertBookButtonIsPresent()
            .selectDate(month: month, day: day, hour: 10, minute: 30, amPm: .pmTime)
            .reserve()
            .assertWeNeedPhoneExist()
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
