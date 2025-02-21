//
//  AuthViewModel.swift
//  My store
//
//  Created by Михаил Супрун on 1/28/25.
//

import ParseCore

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var realName: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = PFUser.current() != nil
    @Published var isSigningUp: Bool = false
    @Published var userAddress: String = ""
    @Published var userPhoneNumber: String = ""
   
    func signIn() {
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if let error = error {
                self.errorMessage = "Failed to login: \(error.localizedDescription)"
                self.isAuthenticated = false
            } else {
                self.errorMessage = ""
                self.isAuthenticated = true
            }
        }
    }
    
    func signUp() {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
    
        user.signUpInBackground { (success, error) in
            if let error = error {
                self.errorMessage = "Failed to sign up: \(error.localizedDescription)"
            } else {
                self.errorMessage = ""
                self.isAuthenticated = success
            }
        }
    }
    func signOut() {
           PFUser.logOutInBackground { [weak self] (error) in
               if let error = error {
                   print("Error logging out: \(error.localizedDescription)")
               } else {
                   DispatchQueue.main.async {
                       self?.isAuthenticated = false
                   }
               }
           }
       }
    func fetchUserContacts() {
        if let user = PFUser.current() {
            if let address = user["address"] as? String {
                userAddress = address
            }
            if let phoneNumber = user["number"] as? String {
                userPhoneNumber = phoneNumber
            }
            if let userName = user["name"] as? String {
                realName = userName
            }
        } else {
            errorMessage = "User not logged in."
        }
    }
}
