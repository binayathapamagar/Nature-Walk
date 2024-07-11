//
//  User.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import Foundation
import FirebaseFirestoreSwift

struct UserObj: Identifiable, Hashable, Codable {
    
    // MARK: Properties
    
    @DocumentID var id: String? = UUID().uuidString
    var name : String = ""
    var email : String = ""
    var contactNumber : String = ""
    var dateAdded: Date = Date()
    var favorites: [Int] = []
    var purchasedTickets: [Ticket] = [Ticket]()
    var paymentInfo: PaymentInfo? = PaymentInfo(cardNumber: "", expiryDate: "", cvv: "")
    
    // MARK: Initializers
    
    init(name: String, email: String, contactNumber: String) {
        self.name = name
        self.email = email
        self.contactNumber = contactNumber
    }
    
    init(name: String, email: String, contactNumber: String, paymentInfo: PaymentInfo) {
        self.name = name
        self.email = email
        self.contactNumber = contactNumber
        self.paymentInfo = paymentInfo
    }
    
}

