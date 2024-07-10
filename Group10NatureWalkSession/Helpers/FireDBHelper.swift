//
//  FiretoreDBHelper.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject {
    
    // MARK: Constants
    
    private let COLLECTION_NAME = "Users"
    
    private let FIELD_USER_NAME = "name"
    private let FIELD_EMAIL = "email"
    private let FIELD_CONTACT_NO = "contactNumber"
    private let FIELD_DATE_ADDED = "dateAdded"
    private let FIELD_FAVORITES = "favorites"
    private let FIELD_PURCHASED_TICKETS = "purchasedTickets"
    private let FIELD_PAYMENT_INFO = "paymentInfo"
    
    // MARK: Properties
    
    private static var shared: FireDBHelper?
    private let db: Firestore
    private var listener: ListenerRegistration?
    
    @Published var userList = [UserObj]() {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var userObj: UserObj? {
        didSet {
            objectWillChange.send()
        }
    }
    
    
    // MARK: Initializers
    
    init(db: Firestore) {
        self.db = db
    }
    
    // MARK: Static methods
    
    static func getInstance() -> FireDBHelper {
        if shared == nil {
            shared = FireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    
    // MARK: User Methods
    
    func insertUser(newUser: UserObj) {
        if let userEmail = getUserEmail(), !userEmail.isEmpty {
            do {
                try self.db
                    .collection(COLLECTION_NAME)
                    .document(userEmail)
                    .setData(from: newUser)
                userList.append(newUser)
            } catch let error {
                print(#function, "Unable to insert the document to firestore: \(error)")
            }
        } else {
            print(#function, "No logged in user")
        }
    }
    
    func getUserFromDB() {
        if let userEmail = getUserEmail(), !userEmail.isEmpty {
            db.collection(COLLECTION_NAME).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    querySnapshot?.documents.forEach({ document in
                        do {
                            var userObj = try document.data(as: UserObj.self)
                            userObj.id = document.documentID
                            self.userObj = userObj
                        } catch let e {
                            print(#function, "No document available: \(e)")
                        }
                    })
                }
            }
        } else {
            print(#function, "No logged in user")
        }
    }
    
    func updateUser(with userObj: UserObj) {
        if let userEmail = getUserEmail(), !userEmail.isEmpty {
            self.db
                .collection(COLLECTION_NAME)
                .document(userEmail)
                .updateData([
                    FIELD_USER_NAME: userObj.name,
                    FIELD_EMAIL: userObj.email,
                    FIELD_CONTACT_NO: userObj.contactNumber,
                    FIELD_FAVORITES: userObj.favorites,
                    FIELD_PURCHASED_TICKETS: userObj.purchasedTickets,
                    FIELD_PAYMENT_INFO: userObj.paymentInfo!
                ]) { error in
                    
                    if let error {
                        print(#function, "Failed to update document: \(userEmail) | \(userObj.name) | \(error)")
                    } else {
                        print(#function, "Successfully updated document: \(userEmail) | \(userObj.name)")
                    }
                    
                }
        } else {
            print(#function, "No logged in user")
        }
    }
    
    func removeCollectionListener() {
        listener?.remove()
        listener = nil
//        bookList.removeAll()
    }
    
    private func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: FireAuthHelper.emailKey)
    }
    
}
