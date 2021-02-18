//
//  RestaurantScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class RestaurantScreen {
    static let app = XCUIApplication()
    
    private let callRestOption = app.collectionViews.staticTexts["+1 310-362-6115"]
    
    let callAlert = app.alerts["Call Republique"]
    
    public func callRestaurant() {
        callRestOption.tap()
    }
}
