//
//  PlacesStub.swift
//  OrderMEUITests
//
//  Created by Igor Dorovskikh on 3/16/21.
//  Copyright © 2021 Boris Gurtovoy. All rights reserved.
//

import SBTUITestTunnelClient

enum PlacesStub {
    case multiplePlaces

    func start() {
        switch self {
        case .multiplePlaces:
            let request = SBTRequestMatch(url: "/places", method: "GET")
            let response = SBTStubResponse(fileNamed: "Places.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
