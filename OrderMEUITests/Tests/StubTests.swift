//
//  StubTests.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 3/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class StubTests: BaseTest {
    
    override func setUp() {
        super.setUp()
        app.launchArguments += ["mockFacebook"]
        app.launchTunnel()
    }

    func testCallRestaurantStubbed() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .callRestaurant)
        
        XCTAssert(restaurantScreen.callAlert.waitForExistence(timeout: 2),
                  "Call alert is not present")
    }

    func testPlacesError() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater(stub: .emptyList)
        XCTAssert(restaurantsListScreen.noPlacesAlert.waitForExistence(timeout: 2),
                  "No Places alert is not visible")
    }
}
