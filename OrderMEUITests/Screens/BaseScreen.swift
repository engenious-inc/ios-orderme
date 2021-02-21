//
//  BaseScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseScreen {
    static let app = XCUIApplication()
    let visibleTimeout: TimeInterval = 2.0

    required init() {}
}
