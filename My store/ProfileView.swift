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
    @State private var isPresented : Bool = false
    var body: some View{
        VStack{
            Text(PFUser.current()?.username ?? "")
            Divider()
            if authViewModel.realName == ""{
                Text("Add your name")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            } else {
                Text(authViewModel.realName)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            }
            Divider()
            if authViewModel.userAddress == ""{
                Text("Add address")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            } else {
                Text(authViewModel.userAddress)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            }
            Divider()
            if authViewModel.userPhoneNumber == ""{
                Text("Add phone number")
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            } else {
                Text(authViewModel.userPhoneNumber)
                    .frame(minHeight: 30)
                    .onTapGesture {
                        isPresented = true
                    }
            }
            Divider()
            Button("Sign out"){
                authViewModel.signOut()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .task(){
            authViewModel.fetchUserContacts()
        }.alert("Change your info", isPresented: $isPresented) {
            TextField("New address", text: $authViewModel.userAddress)
            TextField("New phone number", text: $authViewModel.userPhoneNumber)
            TextField("New name", text: $authViewModel.realName)
            Button("Change", role: .cancel){
                if let user = PFUser.current(){
                    user["address"] = authViewModel.userAddress
                    user["number"] = authViewModel.userPhoneNumber
                    user["name"] = authViewModel.realName
                    user.saveInBackground()
                }
            }
        }
    }
}
