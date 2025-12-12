//
//  BackProtocol.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 11/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import Foundation

protocol BackProtocol {
    @discardableResult
    func backTo<T>(screen: T.Type) -> T where T: BaseScreen
}

extension BackProtocol {
    @discardableResult
    func backTo<T>(screen: T.Type) -> T where T: BaseScreen {
        let backButton = BaseScreen.app.buttons["backButton"]
        backButton.tap()
        return T.init()
    }
}
