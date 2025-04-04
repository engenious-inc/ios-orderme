//
//  CopilotTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 04/04/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
//
import XCTest

class CopilotTests: BaseTest {
    override func setUp() {
        super.setUp()
        app.launchTunnel()
    }

    func testMakeReservationAtBeautyAndEssex() {
        let today = Date()
        guard let futureDate = today.getUIDateForTodayPlus(days: 5) else {
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
            .openBeautyAndEssexRestaurant()
        RestaurantScreen()
            .choose(option: .reservation)
        ReservationsScreen()
            .assertBookButtonIsPresent()
            .typePhoneNumber("3334567790")
            .typeNumberOfPeople("4")
            .selectDate(month: month, day: day, hour: 7, minute: 45, amPm: .pmTime)
            .reserve()
            .assertSuccessAllertExist()
            .tapOK()
            .tapMyReservations()
        MyReservationsScreen()
            .assertCurrentReservationsButtonIsSelected()
            .assertReservationInBeautyAndEssex()
    }
}
