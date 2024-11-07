//
//  BaseScreen.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest

class BaseScreen: Initializable {
    static let app = XCUIApplication()
    let element: XCUIElement
    let description: String
    let timeout: Double

    required init(element: XCUIElement = app, description: String? = nil, timeout: Double? = nil) {
        self.element = element
        self.description = description ?? String(describing: Self.self)
        self.timeout = timeout ?? defaultTimeout
    }
}
