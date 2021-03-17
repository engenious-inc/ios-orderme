//
//  AuthStub.swift
//  OrderMEUITests
//
//  Created by Borys Gurtovyi on 3/17/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import SBTUITestTunnelClient

enum AuthStub {
    case success
    case failure(code: Int)
    
    func start() {
        switch self {
        case .success:
            let request = SBTRequestMatch(url: "/user\\?access_token=UI_TEST_ACCESS_TOKEN", method: "GET")
            let response = SBTStubResponse(fileNamed: "Auth.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        case .failure(let code):
            let request = SBTRequestMatch(url: "/user\\?access_token=UI_TEST_ACCESS_TOKEN", method: "GET")
            let response = SBTStubResponse(response: "", returnCode: code, responseTime: 1)
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
