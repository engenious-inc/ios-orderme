//
//  MenuTests.swift
//  OrderMEUITests
//
//  Created by Yuliya Karanevskaya on 14.07.22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import XCTest
import SBTUITestTunnelClient

class MenuTests: BaseTest {

    override func setUp() {
        super.setUp()
        app.launchArguments += ["mockFacebook"]
        app.launchTunnel {
            AnalyticsStub.success.start()
            // capture all requests
            self.app.monitorRequests(matching: SBTRequestMatch(url: ".*"))
        }
    }
    
    func testMenu() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces, menuStub: .menuList)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        
        let menuScreen = MenuScreen()
        menuScreen.assertMenu()
    }
    
    func testMenuNetworkProblem() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces, menuStub: .emptyList)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.assertNetworkProblemAlert()
    }
    
    func testEnptyMenuNotVisible() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces, menuStub: .emptyList)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        
        let menuScreen = MenuScreen()
        menuScreen.assertMenuNotVisible()
    }
    
    func testMenuList() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces, menuStub: .menuList)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        
        let menuScreen = MenuScreen()
        menuScreen.openFishSection()
        menuScreen.assertFishMenuItem()
    }
    
    func testOrderTotal() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        let menuScreen = MenuScreen()
        menuScreen.openSaladsSection().addMenuItem()
        menuScreen.assertOrderTotal()
    }
    
    func testOrderTotalMultipleItems() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        let menuScreen = MenuScreen()
        menuScreen.openSaladsSection()
            .addMenuItem()
            .tapBackButton()
        menuScreen.openFishSection()
            .addMenuItem()
            .tapBackButton()
        menuScreen.openPastaSection()
            .addMenuItem()
            .assertOrderTotalForMultipleItems()
    }
}
