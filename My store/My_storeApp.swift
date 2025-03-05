//
//  My_storeApp.swift
//  My store
//
//  Created by Михаил Супрун on 1/14/25.
//

import SwiftUI
import ParseCore


@main
struct My_storeApp: App {
    
    init(){
        let configuration = ParseClientConfiguration {
            $0.applicationId = "imTWdtu5WzoJAPwQ3LdiUv2eU5XW3fDx1EFibh3R"
            $0.clientKey = "WwhIhPc5lnmPrAZGbiw1Iza73pd1mbsWKe1zwOoa"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
    }
    var body: some Scene {
        WindowGroup {
            TabViewController()
        }
    }
}

