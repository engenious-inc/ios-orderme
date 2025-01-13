//
//  StubTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 13/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
//

import XCTest

class StubTests: BaseTest {

    override func setUp() {
        super.setUp()
        app.launchArguments += ["mockFacebook"]
        app.launchTunnel()
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
}
