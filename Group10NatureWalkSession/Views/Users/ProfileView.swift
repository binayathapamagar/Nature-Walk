//
//  UserView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: Properties
    
    @Binding var rootView: RootViewState
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
    @State private var isEditing = false
    @State private var isLoading = false
    
    @State private var name = ""
    @State private var email = ""
    @State private var contactNumber = ""
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        header: Text("User Information").font(.headline).padding(.bottom, 8)
                    ) {
                        TextField("Name", text: $name)
                            .padding(.vertical, 8)
                            .disabled(!isEditing)
                        TextField("Email", text: $email)
                            .padding(.vertical, 8)
                            .disabled(true)
                        TextField("Contact Number", text: $contactNumber)
                            .padding(.vertical, 8)
                            .disabled(!isEditing)
                            .keyboardType(.phonePad)
                    }
                }
                
                HStack {
                    if isEditing {
                        Button(action: {
                            updateUser()
                        }) {
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .disabled(isLoading)
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(action: {
                            isEditing = true
                        }) {
                            Text("Edit Profile")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button(action: {
                        fireAuthHelper.logout()
                        rootView = .Login
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            setup()
        }
        .onChange(of: fireDBHelper.userObj) { oldUserObj, newUserObj in
            handleUserObjChange(with: newUserObj)
        }
    }
    
    // MARK: Methods
    
    private func setup() {
        fireDBHelper.getUserFromDB()
    }
    
    private func updateUser() {
        isLoading = true
        fireDBHelper.updateUser(
            with: UserObj(
                name: name,
                email: email,
                contactNumber: contactNumber
            )
        )
        isLoading = false
    }
    
    private func handleUserObjChange(with newUserObjc: UserObj?) {
        if newUserObjc != nil {
            isEditing = false
            isLoading = false
            name = newUserObjc?.name ?? "No name"
            email = newUserObjc?.email ?? "No email"
            contactNumber = newUserObjc?.contactNumber ?? "No contact number"
        } else {
            //User signed out
            fireDBHelper.removeCollectionListener()
        }
    }
    
}

#Preview {
    ProfileView(rootView: .constant(.TabView))
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
}
