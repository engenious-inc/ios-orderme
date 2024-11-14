//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

enum RestaurantOption {
    case detectTable
    case callAWaiter
    case callRestaurant
}

class RestaurantScreen: BaseScreen, BackProtocol {
    private lazy var callAlert: StaticText = element.staticTexts["Call Republique"].build()
    private lazy var callRestOption: StaticText = element.collectionViews.staticTexts["+1 310-362-6115"].build()
    private lazy var detectTableOption: StaticText = element.collectionViews.staticTexts["Detect table"].build()
    private lazy var callAWaiterOption: StaticText = element.collectionViews.staticTexts["Call a waiter"].build()
}

// MARK: - Activities
extension RestaurantScreen {
    @discardableResult
    func callRestaurant() -> Self {
        callRestOption.element.tap()
        return self
    }

    @discardableResult
    func choose(option: RestaurantOption) -> Self {
        switch option {
        case .detectTable:
            detectTableOption.element.tap()
        case .callAWaiter:
            callAWaiterOption.element.tap()
        case .callRestaurant:
            callRestaurant()
        }
        return self
    }
}

// MARK: - Verifications
extension RestaurantScreen {
    @discardableResult
    func assertCallAlertIsPresent() -> Self {
        callAlert.assert(state: .exist)
        return self
    }
}
