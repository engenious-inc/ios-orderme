//
//  PlacesStub.swift
//  orderMe
//
//  Created by Daniil Auhustsinovich on 13/01/2025.
//  Copyright © 2025 Boris Gurtovoy. All rights reserved.
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
