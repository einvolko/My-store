//
//  ProfileView.swift
//  My store
//
//  Created by Михаил Супрун on 1/28/25.
//


import SwiftUI
import ParseCore

struct ProfileView: View{
    @ObservedObject var authViewModel : AuthViewModel
    @State private var isPresentedFirst : Bool = false
    @State private var isPresentedSecond : Bool = false
    @State private var isPresentedThird : Bool = false
    var body: some View{
        VStack{
            Text(PFUser.current()?.username ?? "")
            Divider()
            if authViewModel.realName == ""{
                Text("Add your name")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedThird = true
                    }
            } else {
                Text(authViewModel.realName)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedThird = true
                    }
            }
            Divider()
            if authViewModel.userAddress == ""{
                Text("Add address")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedFirst = true
                    }
            } else {
                Text(authViewModel.userAddress)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedFirst = true
                    }
            }
            Divider()
            if authViewModel.userPhoneNumber == ""{
                Text("Add phone number")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedSecond = true
                    }
            } else {
                Text(authViewModel.userPhoneNumber)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresentedSecond = true
                    }
            }
            Divider()
            Button("Sign out"){
                authViewModel.signOut()}
        }.task(){
            authViewModel.fetchUserContacts()
        }.alert("Change address", isPresented: $isPresentedFirst) {
            TextField("New address", text: $authViewModel.userAddress)
            Button("Change", role: .cancel){
                if let user = PFUser.current(){
                    user["address"] = authViewModel.userAddress
                    user.saveInBackground()
                }
            }
        }.alert("Change phone number", isPresented: $isPresentedSecond) {
            TextField("New phone number", text: $authViewModel.userPhoneNumber)
                .keyboardType(.numberPad)
            Button("Change", role: .cancel){
                if let user = PFUser.current(){
                    user["number"] = authViewModel.userPhoneNumber
                    user.saveInBackground()
                }
            }
        }.alert("Change your name", isPresented: $isPresentedThird) {
            TextField("New name", text: $authViewModel.realName)
            Button("Change", role: .cancel){
                if let user = PFUser.current(){
                    user["name"] = authViewModel.realName
                    user.saveInBackground()
                }
            }
        }
    }
}
