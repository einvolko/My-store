//
//  TabView.swift
//  My store
//
//  Created by Михаил Супрун on 1/27/25.
//


import SwiftUI


struct TabViewController: View{
    @ObservedObject var cart = Cart()
    @ObservedObject var authViewModel = AuthViewModel()
    @ObservedObject var dataModel = DataModel()
    var body: some View {
        TabView {
            Tab("Menu", systemImage: "rectangle.stack") {
                ContentView(dataModel: dataModel, cart: cart)
            }
            Tab("Profile", systemImage: "person.crop.rectangle") {
                if authViewModel.isAuthenticated {
                    ProfileView(authViewModel: authViewModel)
                } else {
                    AuthView(authViewModel: authViewModel)
                    }
                }
            Tab("Basket", systemImage: "basket") {
                BasketView(cart: cart)
            }
            .badge(cart.items.count.description)
        }
        
    }
}
