//
//  AuthView.swift
//  radio
//
//  Created by Artem Raykh on 07.12.2023.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var isNavigationActive = false
    @State private var isLogin = true
    
    var body: some View {
        VStack {
            if isLogin {
                LoginView(
                    authViewModel: authViewModel,
                    isNavigationActive: $isNavigationActive
                )
            } else {
                SignupView(
                    authViewModel: authViewModel,
                    isNavigationActive: $isNavigationActive
                )
            }
            
            HStack {
                Button("Login") {
                    isLogin = true
                }
                .padding()
                
                Button("Signup") {
                    isLogin = false
                }
                .padding()
            }
            
            NavigationLink(
                destination: AppTabView(),
                isActive: $authViewModel.navigate,
                label: {
                    EmptyView()
                }
            )
        }
        .padding()
    }
}

#Preview {
    AuthView(authViewModel: AuthViewModel())
}


struct SignupView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var isNavigationActive: Bool
    
    @State private var username = ""
    @State private var password = ""
    @State private var userType: User.Status = .user
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker("User Type", selection: $userType) {
                ForEach(User.Status.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Sign Up") {
                Task {
                    await authViewModel.signUp(
                        username: username,
                        password: password,
                        status: userType
                    )
                    if authViewModel.navigate {
                        isNavigationActive = true
                    }
                }
            }
            .padding()
        }
    }
}

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var isNavigationActive: Bool
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Sign In") {
                Task {
                    await authViewModel.signIn(
                        username: username,
                        password: password
                    )
                    if authViewModel.navigate {
                        isNavigationActive = true
                    }
                }
            }
            .padding()
        }
    }
}
