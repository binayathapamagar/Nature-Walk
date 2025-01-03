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
    
    private let FIELD_FAVOURITES = "favorites"
    
    private let FIELD_CARD_NUMBER = "cardNumber"
    private let FIELD_CVV = "cvv"
    private let FIELD_EXPIRY_DATE = "expiryDate"
    
    private let FIELD_TICKET_ID = "id"
    private let FIELD_SESSION_ID = "sessionID"
    private let FIELD_SESSION_NAME = "sessionName"
    private let FIELD_TICKET_DATE = "date"
    private let FIELD_TICKET_QUANTITY = "numberOfTickets"
    
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
        
    // MARK: Other methods
    
    func removeCollectionListener() {
        listener?.remove()
        listener = nil
        userList.removeAll()
    }
    
    private func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: FireAuthHelper.emailKey)
    }
    
}

// MARK: User DB Methods extension

extension FireDBHelper {
        
    func addUser(newUser: UserObj) {
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
    
    func fetchUserFromDB() {
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
            var userData: [String: Any] = [
                FIELD_USER_NAME: userObj.name,
                FIELD_EMAIL: userObj.email,
                FIELD_CONTACT_NO: userObj.contactNumber,
                FIELD_FAVORITES: userObj.favorites,
                FIELD_PURCHASED_TICKETS: userObj.purchasedTickets.map { ticket in
                    return [
                        FIELD_TICKET_ID: ticket.id,
                        FIELD_SESSION_ID: ticket.sessionID,
                        FIELD_SESSION_NAME: ticket.sessionName,
                        FIELD_TICKET_DATE: ticket.date,
                        FIELD_TICKET_QUANTITY: ticket.numberOfTickets
                    ]
                }
            ]
            
            if let paymentInfo = userObj.paymentInfo {
                // Convert PaymentInfo to a dictionary
                let paymentInfoDict: [String: Any] = [
                    FIELD_CARD_NUMBER: paymentInfo.cardNumber,
                    FIELD_CVV: paymentInfo.cvv,
                    FIELD_EXPIRY_DATE: paymentInfo.expiryDate,
                ]
                userData[FIELD_PAYMENT_INFO] = paymentInfoDict
            }
            
            self.db
                .collection(COLLECTION_NAME)
                .document(userEmail)
                .updateData(userData) { error in
                    if let error {
                        print(#function, "Failed to update document: \(userEmail) | \(userObj.name) | \(error)")
                    } else {
                        print(#function, "Successfully updated document: \(userEmail) | \(userObj.name)")
                        self.fetchUserFromDB()
                    }
                }
        } else {
            print(#function, "No logged in user")
        }
    }
    
}

// MARK: Favourite sessions extension

extension FireDBHelper {
    
    func addSessionIdToFavs(with id: Int) {
        guard var userObj else {
            print(#function, "User objc is nil!")
            return
        }
        userObj.favorites.append(id)
        updateUser(with: userObj)
    }
    
    func deleteSessionFromFav(with id: Int) {
        guard var userObj else {
            print(#function, "User objc is nil!")
            return
        }
        userObj.favorites.removeAll(where: { $0 == id })
        updateUser(with: userObj)
    }
    
    func removeAllSessionsFromFav() {
        guard var userObj else {
            print(#function, "User objc is nil!")
            return
        }
        userObj.favorites.removeAll()
        updateUser(with: userObj)
    }
    
}

// MARK: Purchases extension

extension FireDBHelper {
    
    func purchaseSessionTicket(with session: Session, and quantity: Int) {
        guard var userObj else {
            print(#function, "User objc is nil!")
            return
        }        
        let ticket = Ticket(
            id: UUID().uuidString,
            sessionID: session.id,
            sessionName: session.name,
            date: session.date,
            numberOfTickets: quantity
        )
        userObj.purchasedTickets.append(ticket)
        updateUser(with: userObj)
    }
    
}
