//
//  AnalyticsStub.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 3/18/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import SBTUITestTunnelClient

enum AnalyticsStub {
    case success

    func start() {
        switch self {
        case .success:
            let request = SBTRequestMatch(url: "/analytics", method: "POST")
            let response = SBTStubResponse(response: "{}")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
