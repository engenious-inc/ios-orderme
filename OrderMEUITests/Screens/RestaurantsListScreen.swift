//
//  RestaurantsListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantsListScreen: BaseScreen, TabBarProtocol {
    private lazy var republiqueRest: StaticText = element.staticTexts["Republique"].build()
    private lazy var allowWhileUsingAppAlert: Alert = Springboard.shared.alerts.firstMatch.buttons["Allow While Using App"].build()

    required init(element: XCUIElement = app, description: String? = nil, timeout: Double? = nil) {
        super .init()
        handleLocationAlertIfNeeded()
    }
}

// MARK: - Activities
extension RestaurantsListScreen {
    @discardableResult
    func openRepubliqueRestaurant() -> Self {
        republiqueRest.tap()
        return self
    }

    @discardableResult
    func handleLocationAlertIfNeeded() -> Self {
        if isLocationAlertVisible() {
            allowWhileUsingAppAlert.tap()
        }
        return self
    }

    private func isLocationAlertVisible() -> Bool {
        return allowWhileUsingAppAlert.element.waitForExistence(timeout: 0.5)
    }
}
