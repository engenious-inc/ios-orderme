//
//  RestaurantsListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantsListScreen: BaseScreen, TabBarProtocol {
    private lazy var republiqueRest = app.staticTexts["Republique"]
    private let allowWhileUsingAppAlert = springboard.alerts.firstMatch.buttons["Allow While Using App"]
    lazy var noPlacesAlert = app.alerts["No Places"]

    required init() {
        super.init()
        handleLocationAlertIfNeeded()
    }

    func handleLocationAlertIfNeeded() {
        if isLocationAlertVisible() {
            allowWhileUsingAppAlert.tap()
        }
    }

    func isLocationAlertVisible() -> Bool {
        return allowWhileUsingAppAlert.waitForExistence(timeout: 0.5)
    }

    public func openRepubliqueRestaurant() -> RestaurantScreen {
        tap(republiqueRest)
        return RestaurantScreen()
    }
}
