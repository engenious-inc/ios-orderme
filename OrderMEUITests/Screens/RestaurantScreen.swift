//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantScreen: BaseScreen {
    private let callRestOption = app.collectionViews.staticTexts["+1 310-362-6115"]

    let callAlert = app.alerts["Call Republique"]

    override init() {
        super.init()
        visible()
    }

    public func callRestaurant() {
        callRestOption.tap()
    }
}

extension RestaurantScreen {
    func visible() {
        guard callRestOption.waitForExistence(timeout: visibleTimeout) else {
            XCTFail("Login screen is not present")
            return
        }
    }
}
