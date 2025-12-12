//
//  WaiterScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 14/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

enum WaiterOption {
    case bringAMenu
    case bringTheBill
    case cleanTheTable
    case callAHookahMan
    case other
    case cancel
}

class WaiterScreen: BaseScreen {
    private lazy var gotItAlert: StaticText = element.staticTexts["The waiter is on his way"].build()
    private lazy var selectTableTextField: TextField = element.textFields["tableNumberTextField"].build()
    private lazy var bringAMenuOption: Button = element.otherElements.buttons["Bring a menu"].build()
    private lazy var bringTheBillOption: Button = element.otherElements.buttons["Bring the bill"].build()
    private lazy var cleanTheTableOption: Button = element.otherElements.buttons["Clean the table"].build()
    private lazy var callAHookahManOption: Button = element.otherElements.buttons["Call a hookah man"].build()
    private lazy var otherOption: Button = element.otherElements.buttons["Other"].build()
    private lazy var cancelOption: Button = element.otherElements.buttons["Cancel"].build()
}

// MARK: - Activities
extension WaiterScreen {
    @discardableResult
    func choose(option: WaiterOption) -> Self {
        switch option {
        case .bringAMenu:
            bringAMenuOption.tap()
        case .bringTheBill:
            bringTheBillOption.tap()
        case .cleanTheTable:
            cleanTheTableOption.tap()
        case .callAHookahMan:
            callAHookahManOption.tap()
        case .other:
            otherOption.tap()
        case .cancel:
            cancelOption.tap()
        }
        return self
    }
}

// MARK: - Verifications
extension WaiterScreen {
    @discardableResult
    func assertGotItAlertIsPresent() -> Self {
        gotItAlert.assert(state: .exist)
        return self
    }
}
