//
//  RestaurantsListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantsListScreen: BaseScreen, TabBarProtocol {
    private let republiqueRest = app.staticTexts["Republique"]
    private let allowWhileUsingAppAlert = springboard.alerts.firstMatch.buttons["Allow While Using App"]

    required init() {
        super.init()
        if visible() == false {
            XCTFail("Restaurants list screen is not present")
            return
        }
    }

    public func openRepubliqueRestaurant() -> RestaurantScreen {
        republiqueRest.tap()
        return RestaurantScreen()
    }

    @discardableResult
    public func handleLocationAlert() -> Self {
        allowWhileUsingAppAlert.tap()
        return self
    }
}

extension RestaurantsListScreen {
    func visible() -> Bool {
        if republiqueRest.waitForExistence(timeout: visibleTimeout) {
            return true
        } else {
            return false
        }
    }
}
