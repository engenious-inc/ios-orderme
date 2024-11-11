//
//  MyReservationsScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 11/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class MyReservationsScreen: BaseScreen {
    private lazy var youDidNotLoginAlert: Alert = element.alerts["You did not login"].build()
}

// MARK: - Verifications
extension MyReservationsScreen {
    @discardableResult
    func assertYouDidNotLoginAlertIsPresent() -> Self {
        youDidNotLoginAlert.assert(state: .exist)
        return self
    }
}
