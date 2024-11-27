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

        XCTContext
            .runActivity(named: "Login and open reservation") { _ in
                LoginScreen()
                    .loginLater()
                RestaurantsListScreen()
                    .openRepubliqueRestaurant()
                RestaurantScreen()
                    .choose(option: .reservation)
            }

        XCTContext
            .runActivity(named: "Attach the screenshot of the reservation") { activity in
                let screen = XCUIScreen.main
                let fullScreenshot = screen.screenshot()
                let fullScreenshotAttachment = XCTAttachment(screenshot: fullScreenshot)
                fullScreenshotAttachment.lifetime = .keepAlways
                activity.add(fullScreenshotAttachment)
            }

        ReservationsScreen()

            .selectDate(month: month, day: day, hour: 10, minute: 30, amPm: .pmTime)
            .reserve()
            .assertWeNeedPhoneExist()
    }
}
