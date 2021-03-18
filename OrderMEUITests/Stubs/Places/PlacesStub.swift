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
        case .failure(let code):
            let request = SBTRequestMatch(url: "/places", method: "GET")
            let response = SBTStubResponse(fileNamed: "Places.json", returnCode: code)
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
