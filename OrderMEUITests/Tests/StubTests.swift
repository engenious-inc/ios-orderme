//
//  StubTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 13/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
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
        LoginScreen()
            .skipFacebook(authStub: .success, placesStub: .multiplePlaces)

        RestaurantsListScreen()
            .openRepubliqueRestaurant()

        RestaurantScreen()
            .choose(option: .callRestaurant)
            .assertCallAlertIsPresent()
     }

    func testPlacesError() {
        LoginScreen()
            .loginLater(stub: .emptyList)

        RestaurantsListScreen()
            .assertNoPlacesAlertIsPresent()
    }

    func test500ServerError() {
        LoginScreen()
            .loginLater(stub: .failure(code: 500))

        RestaurantsListScreen()
            .assertUnexpectedServerErrorAlertIsPresent()
    }

    func testOpenRepubliqueAnalytics() {
        LoginScreen()
            .loginLater(stub: .multiplePlaces)

        assertAnalytics(action: .loginLaterTapped, info: "")
        assertAnalytics(action: .placesListShown, info: "2 places")

        RestaurantsListScreen()
            .openRepubliqueRestaurant()

        assertAnalytics(action: .placeTapped, info: "3")
    }
}
