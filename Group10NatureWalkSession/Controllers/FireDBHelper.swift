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
    
    // MARK: User DB Methods
    
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
            self.db.collection(COLLECTION_NAME).document(userEmail).getDocument { (document, error) in
                if let document = document, document.exists {
                    do {
                        var userObj = try document.data(as: UserObj.self)
                        userObj.id = document.documentID
                        self.userObj = userObj
                        if let index = self.userList.firstIndex(where: { $0.id == userObj.id }) {
                            self.userList[index] = userObj
                        } else {
                            self.userList.append(userObj)
                        }
                    } catch let e {
                        print(#function, "Error decoding user document: \(e)")
                    }
                } else {
                    print(#function, "Document does not exist: \(String(describing: error))")
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
                    FIELD_CONTACT_NO: userObj.contactNumber
                ]) { error in
                    
                    if let error {
                        print(#function, "Failed to update document: \(userEmail) | \(userObj.name) | \(error)")
                    } else {
                        print(#function, "Successfully updated document: \(userEmail) | \(userObj.name)")
                        self.getUserFromDB()
                    }
                    
                }
        } else {
            print(#function, "No logged in user")
        }
    }
    
    // MARK: Other methods
    
    func removeCollectionListener() {
        listener?.remove()
        listener = nil
//        parkingList.removeAll()
        userList.removeAll()
    }
    
    private func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: FireAuthHelper.emailKey)
    }
    
}
