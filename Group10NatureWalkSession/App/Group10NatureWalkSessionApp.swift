//
//  Group10NatureWalkSessionApp.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@main
struct Group10NatureWalkSessionApp: App {
    
    // MARK: Initializers
    
    init() {
        //Initialize firebase services
        FirebaseApp.configure()
    }
    
    // MARK: Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}
