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
    private lazy var callRestOption = BaseScreen.app.collectionViews.firstMatch.cells.element(boundBy: 4)
    private lazy var detectTableOption = BaseScreen.app.collectionViews.firstMatch.cells.element(boundBy: 0)
    private lazy var callAWaiterOption = BaseScreen.app.collectionViews.firstMatch.cells.element(boundBy: 3)

    let callAlert = app.alerts["Call Republique"]

    required init() {
        super.init()
        visible()
    }

    public func choose(option: RestaurantOption) {
        switch option {
        case .detectTable:
            tap(detectTableOption)
        case .callAWaiter:
            tap(callAWaiterOption)
        case .callRestaurant:
            tap(callRestOption)
        }
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
