//
//  RestaurantsListScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantsListScreen: BaseScreen {
    private lazy var republiqueRest: StaticText = element.staticTexts["Republique"].build()
}

// MARK: - Activities
extension RestaurantsListScreen {
    @discardableResult
    func openRepubliqueRestaurant() -> Self {
        republiqueRest.element.tap()
        return self
    }
}
