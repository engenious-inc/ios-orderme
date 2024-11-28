//
//  MyReservationsScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 11/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class MyReservationsScreen: BaseScreen {
    private lazy var youDidNotLoginAlert: Alert = element.alerts["You did not login"].build()
    private lazy var currentReservationsButton: Button = element.segmentedControls.buttons["Current reservations"].build()
    private lazy var hakkasanRestaurantLabel: StaticText = element.cells.staticTexts["Hakkasan"].build()
}

// MARK: - Verifications
extension MyReservationsScreen {
    @discardableResult
    func assertYouDidNotLoginAlertIsPresent() -> Self {
        youDidNotLoginAlert.assert(state: .exist)
        return self
    }

    @discardableResult
    func assertCurrentReservationsButtonIsSelected() -> Self {
        currentReservationsButton.assert(state: .selected)
        return self
    }

    @discardableResult
    func assertReservationInHakkasan() -> Self {
        hakkasanRestaurantLabel.assert(state: .exist)
        return self
    }

    @discardableResult
    func assertReservationDateAndTime(date: String, time: String) -> Self {
        lazy var reservationDate: StaticText = element.staticTexts["\(date)"].build()
        lazy var reservationTime: StaticText = element.staticTexts["\(time)"].build()
        reservationDate.assert(state: .exist)
        reservationTime.assert(state: .exist)
        return self
    }
}
