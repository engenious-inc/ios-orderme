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
    }

    func assertAnalytics(action: AnalyticsAction, info: String) {
        let analytics = app.monitoredRequestsPeekAll()
            // filter only analytics requests
            .filter { $0.originalRequest?.url?.absoluteString.contains("analytics") ?? false }
            // get body JSON
            .compactMap { $0.requestJSON() as? [String: String] }
            // filter by action
            .filter { $0["action"] == action.rawValue }

        guard analytics.count != 0 else {
            XCTFail("Analytics event \(action.rawValue) was not fired")
            return
        }

        guard analytics.count == 1, let analyticsEvent = analytics.first else {
            XCTFail("Analytics event \(action.rawValue) was fired \(analytics.count) times")
            return
        }

        guard analyticsEvent["info"] == info else {
            XCTFail("Analytics event info \(analyticsEvent["info"] ?? "") does not match \(info)")
            return
        }
    }
}
