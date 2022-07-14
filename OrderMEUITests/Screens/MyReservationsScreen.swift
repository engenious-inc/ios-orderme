//
//  MyReservationsScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/21/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class MyReservationsScreen: BaseScreen {
    lazy var youDidNotLoginAlert = app.alerts["You did not login"]

    required init() {
        super.init()
    }
}