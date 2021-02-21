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
    private let callRestOption = app.collectionViews.staticTexts["+1 310-362-6115"]
    private let detectTableOption = app.collectionViews.staticTexts["Detect table"]
    private let callAWaiterOption = app.collectionViews.staticTexts["Call a waiter"]

    let callAlert = app.alerts["Call Republique"]

    required init() {
        super.init()
        visible()
    }

    public func choose(option: RestaurantOption) {
        switch option {
        case .detectTable:
            detectTableOption.tap()
        case .callAWaiter:
            callAWaiterOption.tap()
        case .callRestaurant:
            callRestOption.tap()
        }
    }

    public func callRestaurant() {
        callRestOption.tap()
    }
}

extension RestaurantScreen {
    func visible() {
        guard callRestOption.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Restaurant screen is not present")
            return
        }
    }
}
