//
//  ApiResponse.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import Foundation

struct ApiResponse: Codable {
        
    let coverImages: [CoverImage]
    let sessions: [Session]
    
}
