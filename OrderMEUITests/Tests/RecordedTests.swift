//
//  RecordedTests.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 21/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
//

import Foundation
import XCTest
import StubRecorder

final class RecorderTests: BaseTest {
    lazy var application = XCUIApplication()
    lazy var testName = String(name.dropFirst(2).dropLast()).replacingOccurrences(of: " ", with: "/")
    var stubRecorder: StubRecorder!

    override func setUpWithError() throws {

        application.launchEnvironment["HOST"] = "http://127.0.0.1:3000"

        stubRecorder = try StubRecorder(
            recordModePath: "/Users/daniil/Documents/engenious-advanced-course/ios-orderme/OrderMEUITests/StubResources", // Change to your local path
            playbackModeRelativePath: "StubResources",
            sslCertPath: "",
            sslPrivateKeyPath: "",
            scenarioName: testName,
            host: "127.0.0.1",
            port: .custom(3000),
            endpoint: "http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000",
            record: .off,
            stubMutators: []
        )
        try stubRecorder.start()

    }

    override func tearDownWithError() throws {
        stubRecorder.stop()
    }

    func testExample() {
        application.launch()
        application.buttons["loginLaterButton"].tap()
        sleep(10)
    }
}
