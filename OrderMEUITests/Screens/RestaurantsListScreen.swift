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
    private lazy var hakkasanRest: StaticText = element.staticTexts["Hakkasan"].build()
    private lazy var beautyAndEssexRest: StaticText = element.staticTexts["Beauty & Essex"].build()
    private lazy var allowWhileUsingAppAlert: Alert = Springboard.shared.alerts.firstMatch.buttons["Allow While Using App"].build()
    private lazy var noPlacesAlert: Alert = element.alerts["No Places"].build()
    private lazy var unexpectedServerErrorAlert: Alert = element.alerts["Unexpected server error"].build()

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
    func openHakkasanRestaurant() -> Self {
        hakkasanRest.tap()
        return self
    }

    @discardableResult
    func openBeautyAndEssexRestaurant() -> Self {
        beautyAndEssexRest.tap()
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

// MARK: - Verifications
extension RestaurantsListScreen {
    @discardableResult
    func assertNoPlacesAlertIsPresent() -> Self {
        noPlacesAlert.assert(state: .exist)
        return self
    }

    @discardableResult
    func assertUnexpectedServerErrorAlertIsPresent() -> Self {
        unexpectedServerErrorAlert.assert(state: .exist)
        return self
    }
}
