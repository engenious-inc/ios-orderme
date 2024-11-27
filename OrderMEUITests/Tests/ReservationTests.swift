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
}
