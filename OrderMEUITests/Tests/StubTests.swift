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
    
    func testBringAMenuStubbed() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .callAWaiter)

        XCTAssert(restaurantScreen.callWaiterAlert.waitForExistence(timeout: 2),
                  "CallWaiter alert is not present")
    }
    
    func testSelectTableTextField() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .detectTable)
        
        let selectTableScreen = SelectATableScreen()

        XCTAssert(selectTableScreen.selectTableTextField.waitForExistence(timeout: 2),
                  "Select Table textField is not present")
    }
    
    func testSelectedTableIsOnScreen() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .detectTable)
        
        let selectTableScreen = SelectATableScreen()
        selectTableScreen.selectTableNumberOne()

        XCTAssert(restaurantScreen.tableNumberOneLabel.waitForExistence(timeout: 2),
                  "Select Table textField is not present")
    }
    
    func testMenu() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .menu)
        
        let menuScreen = MenuScreen()
        menuScreen.assertMenu()
    }
    
    func testReservation() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .reservation)
        
        let reservationScreen = ReservationsScreen()
        reservationScreen.selectDate(month: "May", day: "22", hour: 11, minute: 30, amPm: .pmTime)
        reservationScreen.reserve()
        reservationScreen.assertWeNeedPhoneExist()
    }
    
    func testReservationScreenNumberOfPeopleAlert() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.skipFacebook(authStub: .success, placesStub: .multiplePlaces)
        let restaurantScreen = restaurantsListScreen.openRepubliqueRestaurant()
        restaurantScreen.choose(option: .reservation)
        
        let reservationScreen = ReservationsScreen()
        reservationScreen.typePhoneNumber()
        reservationScreen.dismissKeyboard()
        reservationScreen.selectDate(month: "May", day: "22", hour: 11, minute: 30, amPm: .pmTime)
        reservationScreen.reserve()
        reservationScreen.assertWeNeedNumberOfPeopleExist()
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
    
    func test501ServerError() {
        let loginScreen = LoginScreen()
        let restaurantsListScreen = loginScreen.loginLater(stub: .failure(code: 501))
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
    
    func testZeroPlacesAnalytics() {
        let loginScreen = LoginScreen()
        _ = loginScreen.loginLater(stub: .emptyList)

        assertAnalytics(action: .loginLaterTapped, info: "")
        assertAnalytics(action: .placesListShown, info: "0 places")
    }
}
