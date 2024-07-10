//
//  RegisterView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: Properties
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var contactNumber = ""
    
    @Binding var rootView: RootViewState
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    // MARK: Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Form {
                    CustomTextField(placeholder: "Name", text: $name)
                    CustomTextField(placeholder: "Email", text: $email)
                        .autocapitalization(.none)
                    CustomSecureField(placeholder: "Password", text: $password)
                    CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)
                    CustomTextField(placeholder: "Contact Number", text: $contactNumber)
                }
                .shadow(color: .gray.opacity(0.6), radius: 5, x: 0, y: 3)
                
                Button(action: {
                    registerButtonTapped()
                }) {
                    AuthButton(title: "Register", color: .blue)
                }
                .padding(.top, 20)
                
                Spacer()
            } // VStack
            .padding()
            .background(Color(.systemBackground))
            .onChange(of: fireAuthHelper.user) { oldUser, newUser in
                if newUser != nil {
                    registerNewUser()
                }
            }
            .onChange(of: fireDBHelper.userList) { oldValue, newValue in
                if newValue.count != oldValue.count {
                    userRegistered()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }//: NAVIGATION STACK
        .tint(.black)
    } // BODY
    
}

#Preview {
    RegisterView(rootView: .constant(.Register))
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
}

// MARK: RegisterView extension

extension RegisterView {
    
    // MARK: Methods
    
    private func registerButtonTapped() {
        if fieldsAreEmpty() {
            return
        }
        
        guard password == confirmPassword else {
            print(#function, "Password & Confirm Password must be the same!")
            return
        }
        
        guard password.count >= 6 && confirmPassword.count >= 6 else {
            print(#function, "Password & Confirm Password length must contain 6 or more characters!")
            return
        }
        
        // if all the data is validated
        fireAuthHelper.signUp(email: email, password: password)
    }
    
    private func fieldsAreEmpty() -> Bool {
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContactNumber = contactNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty &&
                !trimmedEmail.isEmpty &&
                !trimmedPassword.isEmpty &&
                !trimmedConfirmPassword.isEmpty &&
                !trimmedContactNumber.isEmpty else {
            print(#function, "All of the fields are required!")
            return true
        }
        return false
    }
    
    private func registerNewUser() {
        // Users can only register once, so we will insert the user data in the DB here.
        let newUserObjForDB = UserObj(
            name: name,
            email: fireAuthHelper.user?.email ?? email,
            contactNumber: contactNumber
        )
        fireDBHelper.insertUser(newUser: newUserObjForDB)
    }
    
    private func userRegistered() {
        // TODO: Fetch related stuffs
        // Navigate to home screen
        rootView = .TabView
        dismiss()
    }
    
}
