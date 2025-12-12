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
}

class RestaurantScreen: BaseScreen, BackProtocol {
    private lazy var callAlert: StaticText = element.staticTexts["Call Republique"].build()
    private lazy var callRestOption: Cell = element.collectionViews.cells.element(boundBy: 4).build()
    private lazy var detectTableOption: Cell = element.collectionViews.cells.element(boundBy: 0).build()
    private lazy var callAWaiterOption: Cell = element.collectionViews.cells.element(boundBy: 3).build()
    private lazy var reservationOption: Cell = element.collectionViews.cells.element(boundBy: 2).build()
}

// MARK: - Activities
extension RestaurantScreen {
    @discardableResult
    func callRestaurant() -> Self {
        callRestOption.tap()
        callRestOption.tap()
        return self
    }

    @discardableResult
    func choose(option: RestaurantOption) -> Self {
        switch option {
        case .detectTable:
            detectTableOption.tap()
        case .callAWaiter:
            callAWaiterOption.tap()
        case .callRestaurant:
            callRestaurant()
        case .reservation:
            reservationOption.tap()
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
