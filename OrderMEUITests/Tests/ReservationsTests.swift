//
//  ReservationsTests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/12/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class ReservationsTests: BaseTest {
    func testPhoneNumberRequired() {
        LoginScreen()
            .loginLater()
            .openRepubliqueRestaurant()
            .choose(option: .reservation)

        let today = Date()
        guard let futureDate = today.getUIDateForTodayPlus(days: 3) else {
            XCTFail("Unable to create a future date")
            return
        }
        let day = futureDate.day
        let month = futureDate.month

        let reservationScreen = ReservationsScreen()
        reservationScreen
            .selectDate(month: month, day: day, hour: 10, minute: 30, amPm: .pmTime)
            .reserve()
            .assertWeNeedPhoneExist()
    }
}
