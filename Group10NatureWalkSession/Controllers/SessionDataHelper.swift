//
//  SessionAPIHelper.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import Foundation

class SessionDataHelper: ObservableObject {
    
    // MARK: Static methods
    
    private static var shared: SessionDataHelper?
    
    // MARK: Properties
    
    @Published var homeCoverImages: [CoverImage] = []
    @Published var sessionList: [Session] = []
    @Published var errorMessage: String = ""
        
    // MARK: Static methods
    
    static func getInstance() -> SessionDataHelper {
        if shared == nil {
            shared = SessionDataHelper()
        }
        return shared!
    }
    
    // MARK: Methods
    
    func getSessionsData() {
        let response: ApiResponse = Bundle.main.decode("sessionsList.json")
        homeCoverImages = response.coverImages
        sessionList = response.sessions
        print(#function, "Got the home cover images: \(homeCoverImages.count)")
        print(#function, "Got the sessions data: \(sessionList.count)")
    }
    
}
