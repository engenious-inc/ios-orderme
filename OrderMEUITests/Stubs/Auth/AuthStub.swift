//
//  AuthStub.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 13/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
//

import SBTUITestTunnelClient

enum AuthStub {
    case success

    func start() {
        switch self {
        case .success:
            let request = SBTRequestMatch(url: "/user\\?access_token=UI_TEST_ACCESS_TOKEN", method: "GET")
            let response = SBTStubResponse(fileNamed: "Auth.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
