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
        handleLocationAlertIfNeeded()
        visible()
    }

    public func openRepubliqueRestaurant() -> RestaurantScreen {
        republiqueRest.tap()
        return RestaurantScreen()
    }

    func handleLocationAlertIfNeeded() {
        if isLocationAlertVisible() {
            allowWhileUsingAppAlert.tap()
        }
    }

    func isLocationAlertVisible() -> Bool {
        return allowWhileUsingAppAlert.waitForExistence(timeout: 0.5)
    }
}

extension RestaurantsListScreen {
    func visible() {
        guard republiqueRest.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Restaurants list screen is not present")
            return
        }
    }
}
