//
//  Interactions.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 21/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

protocol Interactions: States {}

extension Interactions {
    func tap() {
        guard element.waitForExistence(timeout: defaultTimeout) else {
            XCTFail("Element \(element.description) not visible")
            return
        }
        element.tap()
    }
}
