//
//  UserView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

//
//  UserView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

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
    @State private var loading = true
    
    @State private var name = ""
    @State private var email = ""
    @State private var contactNumber = ""
    
    @State private var cardNumber = ""
    @State private var cvv = ""
    @State private var expiryDate = ""
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        
                        Section(
                            header: Text("Payment Information (Optional)").font(.headline).padding(.bottom, 8)
                        ) {
                            TextField("Card Number", text: $cardNumber)
                                .padding(.vertical, 8)
                                .disabled(!isEditing)
                                .keyboardType(.numberPad)
                            TextField("CVV", text: $cvv)
                                .padding(.vertical, 8)
                                .disabled(!isEditing)
                                .keyboardType(.numberPad)
                            TextField("Expiry Date", text: $expiryDate)
                                .padding(.vertical, 8)
                                .disabled(!isEditing)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                    }//: FORM
                    
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
                    }//: HSTACK
                    .padding()
                }
                .navigationTitle("Profile")
                
                if loading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        ProgressView()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
            }
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
        if fireDBHelper.userObj == nil {
            loading = true
            fireDBHelper.getUserFromDB()
        }
    }
    
    private func updateUser() {
        isLoading = true
        fireDBHelper.updateUser(
            with: UserObj(
                name: name,
                email: email,
                contactNumber: contactNumber
                // Add other fields as needed
            )
        )
        isLoading = false
    }
    
    private func handleUserObjChange(with newUserObj: UserObj?) {
        loading = false
        if newUserObj != nil {
            handleUIUpdate()
            populateFields(with: newUserObj!)
        } else {
            // User signed out
            fireDBHelper.removeCollectionListener()
        }
    }
    
    private func handleUIUpdate() {
        isEditing = false
        isLoading = false
        loading = false
    }
    
    private func populateFields(with userObj: UserObj) {
        name = userObj.name
        email = userObj.email
        contactNumber = userObj.contactNumber
        
        if let paymentInfo = userObj.paymentInfo {
            cardNumber = paymentInfo.cardNumber
            cvv = paymentInfo.cvv
            expiryDate = paymentInfo.expiryDate
        }
    }
    
}

#Preview {
    ProfileView(rootView: .constant(.TabView))
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
}
