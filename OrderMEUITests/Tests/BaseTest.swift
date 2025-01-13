//
//  BaseTest.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 2/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import XCTest
import SBTUITestTunnelClient

class BaseTest: XCTestCase {

    static var shared: BaseTest!

    override func setUpWithError() throws {
        BaseTest.shared = self
        continueAfterFailure = false
        app.launchArguments = ["startStubServer", "logOut"]
        app.launchTunnel()
    }
}
