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
    case emptyList
    case failure(code: Int)

    func start() {
        switch self {
        case .multiplePlaces:
            let request = SBTRequestMatch(url: "/places", method: "GET")
            let response = SBTStubResponse(fileNamed: "Places.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        case .emptyList:
            let request = SBTRequestMatch(url: "/places", method: "GET")
            let response = SBTStubResponse(fileNamed: "EmptyPlaces.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        case .failure(code: let code):
            let request = SBTRequestMatch(url: "/places", method: "GET")
            let response = SBTStubResponse(fileNamed: "Places.json", returnCode: code)
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
