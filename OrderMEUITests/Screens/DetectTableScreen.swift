//
//  DetectTableScreen.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 14/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

class DetectTableScreen: BaseScreen {
    private lazy var selectTableTextField: TextField = element.textFields["tableNumberTextField"].build()
    private lazy var selectTableButton: Button = element.buttons["Select table"].build()
}

// MARK: - Activities
extension DetectTableScreen {
    func selectTable(number table: Int) {
        selectTableTextField.element.tap()
        selectTableTextField.element.typeText(String(table))
        selectTableButton.element.tap()
    }
}
