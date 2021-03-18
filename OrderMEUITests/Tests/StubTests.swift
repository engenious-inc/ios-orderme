//
//  StubTests.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 3/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest
import SBTUITestTunnelClient

enum AnalyticsAction: String {
     case loginLaterTapped
     case placesListShown
     case placeTapped
}

class StubTests: BaseTest {

    override func setUp() {
        super.setUp()
        app.launchArguments += ["mockFacebook"]
        app.launchTunnel {
            AnalyticsStub.success.start()
            // capture all requests
            self.app.monitorRequests(matching: SBTRequestMatch(url: ".*"))
        }
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

    func test500ServerError() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater(stub: .failure(code: 500))
        XCTAssert(restaurantsListScreen.unexpectedServerError.waitForExistence(timeout: 2),
                  "Unexpected Server Error is not visible")
    }

    func testOpenRepubliqueAnalytics() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater(stub: .multiplePlaces)

        assertAnalytics(action: .loginLaterTapped, info: "")
        assertAnalytics(action: .placesListShown, info: "2 places")

        restaurantsListScreen.openRepubliqueRestaurant()

        assertAnalytics(action: .placeTapped, info: "3")
    }
}
