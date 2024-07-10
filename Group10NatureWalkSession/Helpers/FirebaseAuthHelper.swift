//
//  FirebaseAuthHelper.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import Foundation
import FirebaseAuth

class FireAuthHelper: ObservableObject {
    
    // MARK: Properties
    
    //Firebase in-built user.
    @Published var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    // MARK: Static properties
    
    static let emailKey = "KEY_EMAIL"
    private static var shared: FireAuthHelper?
    
    // MARK: Static methods
    
    static func getInstance() -> FireAuthHelper {
        if shared == nil {
            shared = FireAuthHelper()
        }
        return shared!
    }
    
    // MARK: Methods
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let user else {
                //No change in the auth state if the reference to the self object is the same, so action to perform.
                print(#function, "No change to auth state!")
                return
            }
            self?.user = user
        }
    }
    
    func signUp(email : String, password : String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            guard let result = authResult else {
                print(#function, "Error while creating account: \(error?.localizedDescription ?? "")")
                return
            }
            
            print(#function, "Auth result: \(result)")
            
            switch authResult {
            case .none:
                print(#function, "Unable to create account: \(result.description)")
            case .some(_):
                print(#function, "Successfully created your account.")
                
                //Access the default user object
                saveUserState(with: authResult)
            }
        }
        
    }
    
    func signIn(email : String, password : String){
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            guard let result = authResult else {
                print(#function, "Error signing in: \(error?.localizedDescription ?? "")")
                return
            }
            
            print(#function, "Auth result: \(result)")
            
            switch authResult {
            case .none:
                print(#function, "Unable to create account: \(result.description)")
            case .some(_):
                print(#function, "Successfully signed in.")
                    
                saveUserState(with: authResult)
            }
        }
        
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            print(#function, "Successfully signed the user out.")
            UserDefaults.standard.removeObject(forKey: FireAuthHelper.emailKey)
        } catch let e {
            print(#function, "Error logging the user out: \(e)")
        }
    }
    
    private func saveUserState(with authResult: AuthDataResult?) {
        //Access the default user object
        self.user = authResult?.user
        
        print(#function, "Logged in user's email: \(user?.email ?? "No email")")
        print(#function, "User's last logged in date: \(user?.metadata.lastSignInDate ?? Date())")
        print(#function, "User description: \(user?.description ?? "No description")")
                
        UserDefaults.standard.set(self.user?.email, forKey: FireAuthHelper.emailKey)
    }
    
}
