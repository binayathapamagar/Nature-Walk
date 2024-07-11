//
//  PurchaseListView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct PurchaseListView: View {
    
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
            .navigationTitle("Purchases")
            
        }//: NAVIGATIONVIEW
    }
    
}

// MARK: FavouriteListView extension

extension PurchaseListView {
    
    // MARK: Methods
    
    private func setup() {
        
    }
    
}

#Preview {
    PurchaseListView()
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
        .environmentObject(SessionDataHelper.getInstance())
}
