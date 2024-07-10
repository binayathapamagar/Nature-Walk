//
//  LoginView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: Properties
    
    @Binding var rootView: RootViewState
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var showSignUp : Bool = false
    
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    private let gridItems : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()
                
                VStack(spacing: 16) {
                    TextField("Enter Email", text: self.$email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    SecureField("Enter Password", text: self.$password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal)
                
                Button(action: {
                    loginButtonTapped()
                }) {
                    AuthButton(title: "Login", color: .blue)
                }
                .padding(.horizontal)
                
                Button {
                    self.showSignUp = true
                } label: {
                    AuthButton(title: "Register", color: .green)
                }
                .padding(.horizontal)
                
                Spacer()
                
            } // VStack ends
            .padding()
            .background(Color(.systemBackground))
            .onAppear{
                setup()
            }
            .onChange(of: fireAuthHelper.user, { oldUserObj, newUserObj in
                if newUserObj != nil {
                    userLoggedIn()
                }
            })
            .navigationDestination(isPresented: self.$showSignUp) {
                RegisterView(rootView: $rootView)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
            }
            .navigationTitle("Login")
        }//: NAVIGATION STACK
        .tint(.black)
        
    } // BODY
    
}

#Preview {
    LoginView(
        rootView: .constant(.Login)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
}

// MARK: LoginView Extension

extension LoginView {
    
    // MARK: Methods
    
    private func setup() {
        self.email = UserDefaults.standard.string(forKey: FireAuthHelper.emailKey) ?? ""
        self.password = UserDefaults.standard.string(forKey: "KEY_PASSWORD") ?? ""
    }
    
    private func loginButtonTapped() {
        if !self.email.isEmpty && !self.password.isEmpty {
            fireAuthHelper.signIn(email: email, password: password)
        } else {
            print(#function, "Email and Password cannot be empty")
        }
    }
    
    private func userLoggedIn() {
        fireDBHelper.removeCollectionListener()
//                    fireDBHelper.getAllParkingHistory()
        //navigate to home screen
        rootView = .TabView
    }
    
}
