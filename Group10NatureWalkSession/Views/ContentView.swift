//
//  ContentView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            TabView {
                
                SessionListView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2")
                        Text("Sessions")
                    }
                
                FavouriteListView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favourites")
                    }
                
                PurchaseListView()
                    .tabItem {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Purchases")
                    }
                
                UserView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profile")
                    }

            }//: TabView
            .tint(.black)
        }//: NavigationStack
        .onAppear {
            SessionDataHelper().getSessionsData()
        }
    }//: Body
}

#Preview {
    ContentView()
}
