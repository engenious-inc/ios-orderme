//
//  MenuScreen.swift
//  OrderMEUITests
//
//  Created by Yuliya Karanevskaya on 10.07.22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import XCTest

class MenuScreen: BaseScreen {

    lazy var saladsCellLabel = app.cells.staticTexts["SALADS AND VEGETABLES"]
    lazy var fishCellLabel = app.cells.staticTexts["FISH"]
    lazy var pASTACellLabel = app.cells.staticTexts["PASTA"]
    lazy var meatCellLabel = app.cells.staticTexts["MEAT"]
    lazy var lasagnaCellLabel = app.cells.staticTexts["Lasagna"]
    lazy var pastaCellLabel = app.cells.staticTexts["Pasta"]
    lazy var addMenuItemButton = app.buttons["plusButton"].firstMatch
    lazy var oderTotalLabel = app.staticTexts["18.0"]

    required init() {
        super.init()
    }
}

// MARK: - Actions
extension MenuScreen {
    @discardableResult
    func openSaladsSection() -> Self {
        tap(saladsCellLabel)
        return self
    }
    
    @discardableResult
    func addMenuItem() -> Self {
        tap(addMenuItemButton)
        return self
    }
}
    
// MARK: - Verifications
extension MenuScreen {
    @discardableResult
    func assertMenu() -> Self {
        XCTAssert(saladsCellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        XCTAssert(fishCellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        XCTAssert(pASTACellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        XCTAssert(meatCellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        XCTAssert(lasagnaCellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        XCTAssert(pastaCellLabel.waitForExistence(timeout: 3),
                      "Menu is not visible")
        return self
    }
    
    @discardableResult
    func assertOrderTotal() -> Self {
        XCTAssert(oderTotalLabel.waitForExistence(timeout: 3),
                      "Oder total is not visible")
        return self
    }
}

    


