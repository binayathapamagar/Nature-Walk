//
//  Ticket.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import Foundation

struct Ticket: Identifiable, Hashable, Codable {
    var id: String
    var sessionID: Int
    var sessionName: String
    var date: String
    var numberOfTickets: Int
}
