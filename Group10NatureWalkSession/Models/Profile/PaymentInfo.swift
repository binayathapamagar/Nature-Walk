//
//  PaymentInfo.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import Foundation

struct PaymentInfo: Hashable, Codable {
    var cardNumber: String
    var expiryDate: String
    var cvv: String
}
