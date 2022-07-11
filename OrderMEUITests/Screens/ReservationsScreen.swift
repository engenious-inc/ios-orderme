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
    private lazy var monthDayPicker: XCUIElement = app.pickerWheels.element(boundBy: 0)
    private lazy var hourPicker: XCUIElement = app.pickerWheels.element(boundBy: 1)
    private lazy var minutePicker: XCUIElement = app.pickerWheels.element(boundBy: 2)
    private lazy var amPmPicker: XCUIElement = app.pickerWheels.element(boundBy: 3)

    private lazy var bookButton: XCUIElement = app.staticTexts["Book"]
    private lazy var weNeedPhoneAlert: XCUIElement = app.alerts["We need your phone number"]
    private lazy var didNotLoginAlert: XCUIElement = app.alerts["You did not login"]
    private lazy var weNeedNumberOfPeopleAlert: XCUIElement = app.alerts["We need the number of people"]
    private lazy var phoneNumberTextFiled: XCUIElement = app.textFields["Phone number"]
    private lazy var numberOfPeopleTextFiled: XCUIElement = app.textFields["Number of people"]
    private lazy var pickDateLabel: XCUIElement = app.staticTexts["Pick a date"]

    required init() {
        super.init()
        visible()
    }
}

// MARK: - Actions
extension ReservationsScreen {
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
    func typePhoneNumber() -> Self {
        tap(phoneNumberTextFiled)
        type("111", element: phoneNumberTextFiled)
        return self
    }

    @discardableResult
    func typeNumberOfPeople() -> Self {
        tap(numberOfPeopleTextFiled)
        type("3", element: numberOfPeopleTextFiled)
        return self
    }
    
    @discardableResult
    func dismissKeyboard() -> Self {
        tap(pickDateLabel)
        return self
    }
}

// MARK: - Verifications
extension ReservationsScreen {
    @discardableResult
    func assertWeNeedPhoneExist() -> Self {
        XCTAssertTrue(weNeedPhoneAlert.waitForExistence(timeout: visibleTimeout),
                      "We need your phone number alert is not visible")
        return self
    }
    
    @discardableResult
    func assertWeNeedNumberOfPeopleExist() -> Self {
        XCTAssertTrue(weNeedNumberOfPeopleAlert.waitForExistence(timeout: visibleTimeout),
                      "We need the number of people alert is not visible")
        return self
    }
    
    @discardableResult
    func asserDidNotLoginAlert() -> Self {
        XCTAssertTrue(didNotLoginAlert.waitForExistence(timeout: visibleTimeout),
                      "You did not login alert is not visible")
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
