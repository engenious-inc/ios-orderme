//
//  SelectATableScreen.swift
//  OrderMEUITests
//
//  Created by Yuliya Karanevskaya on 10.07.22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import Foundation

class SelectATableScreen: BaseScreen {

    lazy var selectTableTextField = app.textFields["tableNumberTextField"]
    lazy var selectTableButton = app.buttons["Select table"]

    required init() {
        super.init()
    }
}

// MARK: - Actions
extension SelectATableScreen {
    @discardableResult
    func selectTableNumberOne() -> Self {
        tap(selectTableTextField)
        type("1", element: selectTableTextField)
        pressSelectTableButton()
        return self
    }
    
    @discardableResult
    func pressSelectTableButton() -> Self {
        tap(selectTableButton)
        return self
    }
}

// MARK: - Verifications
extension SelectATableScreen {}
    


