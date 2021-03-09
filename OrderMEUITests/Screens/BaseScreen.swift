//
//  BaseScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseScreen {
    static let app = XCUIApplication()
    let visibleTimeout: TimeInterval = 2.0
    static let springboard: XCUIApplication = .init(bundleIdentifier: "com.apple.springboard")

    required init() {}

    func tap(_ element: XCUIElement) {
        guard element.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("\(element.description) is not visible")
            return
        }
        element.tap()
    }

    func type(_ text: String, element: XCUIElement) {
        guard element.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("\(element.description) is not visible")
            return
        }
        element.typeText(text)
    }
}
