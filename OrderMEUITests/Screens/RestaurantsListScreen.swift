//
//  RestaurantsListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantsListScreen: BaseScreen {
    private let republiqueRest = app.staticTexts["Republique"]

    public func openRepubliqueRestaurant() {
        republiqueRest.tap()
    }
}
