//
//  FavouriteListView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct FavouriteListView: View {
    
    // MARK: Properties
        
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                
                
            }//: SCROLLVIEW
            .onAppear {
                setup()
            }
            .navigationTitle("Favs")
            
        }//: NAVIGATIONVIEW
    }
    
}

// MARK: FavouriteListView extension

extension FavouriteListView {
    
    // MARK: Methods
    
    private func setup() {
        fireDBHelper.fetchUserFavSessions()
    }
    
}

#Preview {
    FavouriteListView()
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
        .environmentObject(SessionDataHelper.getInstance())
}
