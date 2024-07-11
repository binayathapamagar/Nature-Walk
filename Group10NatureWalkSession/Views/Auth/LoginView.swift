//
//  LoginView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

//
//  LoginView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

//
//  LoginView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    // MARK: Properties
    
    @Binding var rootView: RootViewState
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showSignUp: Bool = false
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
    // MARK: Constants
    
    let FIELD_REMEMBER_ME = "KEY_REMEMBER_ME"
    let FIELD_REMEMBER_EMAIL = "KEY_REMEMBER_EMAIL"
    let FIELD_REMEMBER_PASS = "KEY_REMEMBER_PASSWORD"
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    AuthHeadingView(title: "Login", description: "Login to access more features")
                    
                    Form {
                        CustomTextField(placeholder: "Email", text: $email)
                            .padding(.vertical, 12)
                            .autocapitalization(.none)
                        CustomSecureField(placeholder: "Password", text: $password)
                        Toggle(isOn: $rememberMe) {
                            Text("Remember Me")
                        }
                        .padding(.vertical, 4)
                        .toggleStyle(CheckboxStyle())
                    }
                    .formStyle(ColumnsFormStyle())
                    .padding(.vertical, 12)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            loginButtonTapped()
                        }) {
                            AuthButton(title: "Login", color: .blue)
                        }
                        
                        Button {
                            self.showSignUp = true
                        } label: {
                            AuthButton(title: "Register", color: .green)
                        }
                    }
                                        
                } //: VSTACK
                .padding(.horizontal, 8)
            }//: SCROLLVIEW
            .padding()
            .onAppear {
                setup()
            }
            .onChange(of: fireAuthHelper.user, { oldUserObj, newUserObj in
                handleUserObjValChange(with: newUserObj)
            })
            .navigationDestination(isPresented: self.$showSignUp) {
                RegisterView(rootView: $rootView)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
            }
            .navigationBarTitleDisplayMode(.inline)
        } //: NAVIGATIONSTACK
        
    } // BODY
    
}

// MARK: LoginView Extension

extension LoginView {
    
    // MARK: Methods
    
    private func setup() {
        setupRememberMe()
        updateUserObj()
    }
    
    private func setupRememberMe() {
        self.email = UserDefaults.standard.string(forKey: FIELD_REMEMBER_EMAIL) ?? ""
        self.password = UserDefaults.standard.string(forKey: FIELD_REMEMBER_PASS) ?? ""
        self.rememberMe = UserDefaults.standard.bool(forKey: FIELD_REMEMBER_ME)
    }
    
    private func updateUserObj() {
        if fireAuthHelper.user == nil {
            fireDBHelper.userObj = nil
        }
    }
    
    private func loginButtonTapped() {
        if !self.email.isEmpty && !self.password.isEmpty {
            fireAuthHelper.signIn(email: email, password: password)
        } else {
            print(#function, "Email and Password cannot be empty")
        }
    }
    
    private func updateRememberMe() {
        if rememberMe {
            UserDefaults.standard.set(self.email, forKey: FIELD_REMEMBER_EMAIL)
            UserDefaults.standard.set(self.password, forKey: FIELD_REMEMBER_PASS)
            UserDefaults.standard.set(self.rememberMe, forKey: FIELD_REMEMBER_ME)
        } else {
            UserDefaults.standard.removeObject(forKey: FIELD_REMEMBER_EMAIL)
            UserDefaults.standard.removeObject(forKey: FIELD_REMEMBER_PASS)
            UserDefaults.standard.removeObject(forKey: FIELD_REMEMBER_ME)
        }
    }
    
    private func handleUserObjValChange(with newFireUserObj: User?) {
        if newFireUserObj != nil {
            updateRememberMe()
            fireDBHelper.removeCollectionListener()
            fireDBHelper.getUserFromDB()
            //navigate to home screen
            rootView = .Profile
        }
    }
    
    private func userLoggedIn() {
        fireDBHelper.removeCollectionListener()
        //                    fireDBHelper.getAllParkingHistory()
        //navigate to home screen
        rootView = .Profile
    }
    
}

#Preview {
    LoginView(
        rootView: .constant(.Login)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
}
