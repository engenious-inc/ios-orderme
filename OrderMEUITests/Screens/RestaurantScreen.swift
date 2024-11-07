//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantScreen: BaseScreen {
    private lazy var callRestOption: StaticText = element.collectionViews.staticTexts["+1 310-362-6115"].build()
    private lazy var callAlert: StaticText = element.staticTexts["Call Republique"].build()
}

// MARK: - Activities
extension RestaurantScreen {
    @discardableResult
    func callRestaurant() -> Self {
        callRestOption.element.tap()
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
