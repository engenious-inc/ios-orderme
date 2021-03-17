//
//  ReservationsTests.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/12/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class ReservationsTests: BaseTest {
    override func setUp() {
        super.setUp()
        app.launchTunnel()
    }

    func testPhoneNumberRequired() {
        XCTContext
            .runActivity(named: "Login and open reservation") { _ in
            LoginScreen()
                .loginLater()
                .openRepubliqueRestaurant()
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
