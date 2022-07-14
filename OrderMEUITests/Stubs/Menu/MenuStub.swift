//
//  MenuStub.swift
//  OrderMEUITests
//
//  Created by Yuliya Karanevskaya on 14.07.22.
//  Copyright © 2022 Boris Gurtovoy. All rights reserved.
//

import SBTUITestTunnelClient

enum MenuStub {
    case menuList
    case emptyList
    
    
    func start() {
        switch self {
        case .menuList:
            let request = SBTRequestMatch(url: "/menu/3", method: "GET")
            let response = SBTStubResponse(fileNamed: "Menu.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        case .emptyList:
            let request = SBTRequestMatch(url: "/menu/3", method: "GET")
            let response = SBTStubResponse(fileNamed: "EmptyMenu.json")
            BaseTest.shared.app.stubRequests(matching: request, response: response)
        }
    }
}
