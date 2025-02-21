//
//  ProfileView.swift
//  My store
//
//  Created by Михаил Супрун on 1/28/25.
//

import SwiftUI


struct AuthView: View {
    
    @ObservedObject var authViewModel : AuthViewModel
    
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    TextField("Username", text: $authViewModel.username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    if authViewModel.isSigningUp {
                        TextField("Email", text: $authViewModel.email)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    
                    SecureField("Password", text:  $authViewModel.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    // Toggle between sign-in and sign-up
                    Button(action: {
                        authViewModel.isSigningUp ? authViewModel.signUp() : authViewModel.signIn()
                    }) {
                        Text(authViewModel.isSigningUp ? "Sign Up" : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    // Toggle view mode
                    Button(action: {
                        authViewModel.isSigningUp.toggle()
                    }) {
                        Text(authViewModel.isSigningUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text(authViewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                .navigationTitle(authViewModel.isSigningUp ? "Sign Up" : "Sign In")
            }
        }
    }

