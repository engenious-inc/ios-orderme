//
//  ReservationsScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/12/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

enum AmPm: String {
    case amTime = "AM"
    case pmTime = "PM"
}

class ReservationsScreen: BaseScreen {
    private let monthDayPicker: XCUIElement = app.pickerWheels.element(boundBy: 0)
    private let hourPicker: XCUIElement = app.pickerWheels.element(boundBy: 1)
    private let minutePicker: XCUIElement = app.pickerWheels.element(boundBy: 2)
    private let amPmPicker: XCUIElement = app.pickerWheels.element(boundBy: 3)

    private let bookButton: XCUIElement = app.staticTexts["Book"]
    private let weNeedPhoneAlert: XCUIElement = app.alerts["We need your phone number"]

    required init() {
        super.init()
        visible()
    }

    @discardableResult
    func selectDate(month: String, day: String, hour: Int, minute: Int, amPm: AmPm) -> Self {
        guard hour > 0 && hour < 13 && minute >= 0 && minute < 60 && minute % 5 == 0 else {
            XCTFail("Incorrect date is provided")
            return self
        }

        let monthDay = "\(month) \(day)"
        monthDayPicker.adjust(toPickerWheelValue: monthDay)
        hourPicker.adjust(toPickerWheelValue: hour.description)
        minutePicker.adjust(toPickerWheelValue: minute.description)
        amPmPicker.adjust(toPickerWheelValue: amPm.rawValue)
        return self
    }

    @discardableResult
    func reserve() -> Self {
        tap(bookButton)
        return self
    }

    @discardableResult
    func assertWeNeedPhoneExist() -> Self {
        XCTAssertTrue(weNeedPhoneAlert.waitForExistence(timeout: visibleTimeout),
                      "We need your phone number alert is not visible")
        return self
    }
}

extension ReservationsScreen {
    func visible() {
        guard bookButton.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Reservations Screen is not present")
            return
        }
    }
}
