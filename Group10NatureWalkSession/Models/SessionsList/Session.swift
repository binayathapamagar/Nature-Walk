//
//  Session.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import Foundation

struct Session: Codable, Identifiable {
        
    let id: Int
    let name: String
    let description: String
    let starRating: Double
    let guideName: String
    let guidePhoneNum: String
    let photos: [SessionCoverImage]
    let pricingPerPerson: Double
    let date: String
    let latitude: Double
    let longitude: Double
    
}

struct SessionCoverImage: Codable, Identifiable {
        
    let id: Int
    let name: String
    
}
