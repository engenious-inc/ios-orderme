//
//  TextField.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 14/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class TextField: BaseElement {
    @discardableResult
    func type(_ text: String) -> Self {
        guard element.waitForExistence(timeout: defaultTimeout) else {
            XCTFail("\(element.description) is not visible")
            return self
        }
        element.typeText(text)
        return self
    }
}
