//
//  ReservationScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 27/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//
import XCTest

enum AmPm: String {
    case amTime = "AM"
    case pmTime = "PM"
}

class ReservationsScreen: BaseScreen, TabBarProtocol {
    private lazy var monthDayPicker: PickerWheel = element.pickerWheels.element(boundBy: 0).build()
    private lazy var hourPicker: PickerWheel = element.pickerWheels.element(boundBy: 1).build()
    private lazy var minutePicker: PickerWheel = element.pickerWheels.element(boundBy: 2).build()
    private lazy var amPmPicker: PickerWheel = element.pickerWheels.element(boundBy: 3).build()

    private lazy var bookButton: Button = element.staticTexts["Book"].build()
    private lazy var weNeedPhoneAlert: Alert = element.alerts["We need your phone number"].build()
    private lazy var phoneNumberTextField: TextField = element.textFields["Phone number"].build()
    private lazy var numberOfPeopleTextField: TextField = element.textFields["Number of people"].build()
    private lazy var successAlert: Alert = element.alerts["Success!"].build()
    private lazy var okButton: Button = element.buttons["OK"].build()
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
        monthDayPicker.element.adjust(toPickerWheelValue: monthDay)
        hourPicker.element.adjust(toPickerWheelValue: hour.description)
        minutePicker.element.adjust(toPickerWheelValue: minute.description)
        amPmPicker.element.adjust(toPickerWheelValue: amPm.rawValue)
        return self
    }

    @discardableResult
    func reserve() -> Self {
        bookButton.tap()
        return self
    }

    @discardableResult
    func tapOK() -> Self {
        okButton.tap()
        return self
    }

    @discardableResult
    func typePhoneNumber(_ phone: String) -> Self {
        phoneNumberTextField.tap()
        phoneNumberTextField.type(phone)
        return self
    }

    @discardableResult
    func typeNumberOfPeople(_ number: String) -> Self {
        numberOfPeopleTextField.tap()
        numberOfPeopleTextField.type(number)
        return self
    }
}

// MARK: - Verifications
extension ReservationsScreen {
    @discardableResult
    func assertWeNeedPhoneExist() -> Self {
        weNeedPhoneAlert.assert(state: .exist)
        return self
    }

    @discardableResult
    func assertBookButtonIsPresent() -> Self {
        bookButton.assert(state: .exist)
        return self
    }

    @discardableResult
    func assertSuccessAllertExist() -> Self {
        successAlert.assert(state: .exist)
        return self
    }
}
