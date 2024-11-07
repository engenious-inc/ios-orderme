//
//  Initializable.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 07/11/2024.
//  Copyright © 2024 Boris Gurtovoy. All rights reserved.
//

import XCTest

protocol Initializable {
    var element: XCUIElement { get }
    var description: String { get }
    var timeout: Double { get }

    init(element: XCUIElement, description: String?, timeout: Double?)
}
