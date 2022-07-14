//
//  BackProtocol.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/21/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import Foundation

protocol BackProtocol {
    @discardableResult
    func backTo<T>(screen: T.Type) -> T where T: BaseScreen
}

extension BackProtocol {
    @discardableResult
    func backTo<T>(screen: T.Type) -> T where T: BaseScreen {
        let backButton = BaseTest.shared.app.buttons["backButton"]
        backButton.tap()
        return T.init()
    }
}