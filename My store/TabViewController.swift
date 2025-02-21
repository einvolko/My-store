//
//  TabView.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//

import Foundation
import SwiftUI


struct TabViewController: View{
    @ObservedObject var basketStorage = BasketStorage()
    @ObservedObject var authViewModel = AuthViewModel()
    var body: some View {
        TabView {
            Tab("Menu", systemImage: "rectangle.stack") {
                ContentView(globalStorage: basketStorage)
            }
            Tab("Profile", systemImage: "person.crop.rectangle") {
                if authViewModel.isAuthenticated {
                    ProfileView(authViewModel: authViewModel)
                } else {
                    AuthView(authViewModel: authViewModel)
                    }
                }
            Tab("Basket", systemImage: "basket") {
                BasketView(basketStorage: basketStorage)
            }
            .badge($basketStorage.basketArray.count.description)
        }
        
    }
}
