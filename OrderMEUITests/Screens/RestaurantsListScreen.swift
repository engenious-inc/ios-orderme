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

    required init() {
        super.init()
        visible()
    }

    public func openRepubliqueRestaurant() -> RestaurantScreen {
        tap(republiqueRest)
        return RestaurantScreen()
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
