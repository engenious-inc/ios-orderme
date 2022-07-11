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
    case reservation
    case menu
}

class RestaurantScreen: BaseScreen, BackProtocol {
    private lazy var callRestOption = app.collectionViews.firstMatch.cells.element(boundBy: 4)
    private lazy var detectTableOption = app.collectionViews.firstMatch.cells.element(boundBy: 0)
    private lazy var callAWaiterOption = app.collectionViews.firstMatch.cells.element(boundBy: 3)
    private lazy var reservationOption = app.collectionViews.firstMatch.cells.element(boundBy: 2)
    private lazy var menuOption = app.collectionViews.firstMatch.cells.element(boundBy: 1)

    lazy var callAlert = app.alerts["Call Republique"]
    lazy var callWaiterAlert = app.alerts["Pick the table, please"]
    lazy var tableNumberOneLabel = app.staticTexts["Table #1"]

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
        case .reservation:
            tap(reservationOption)
        case .menu:
            tap(menuOption)
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
