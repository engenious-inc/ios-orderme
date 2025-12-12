//
//  TabBarProtocol.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 11/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

protocol TabBarProtocol {
    func tapHome() -> Self
    func tapMyReservations() -> Self
    func tapMyOrders()
}

extension TabBarProtocol {
    @discardableResult
    func tapHome() -> Self {
        XCUIApplication().tabBars["Tab Bar"].buttons["Home"].tap()
        return self
    }

    @discardableResult
    func tapMyReservations() -> Self {
        XCUIApplication().tabBars["Tab Bar"].buttons["My reservations"].tap()
        return self
    }

    func tapMyOrders() {
        XCUIApplication().tabBars["Tab Bar"].buttons["My orders"].tap()
    }
}
