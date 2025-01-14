//
//  AnalyticsStub.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 14/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
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
