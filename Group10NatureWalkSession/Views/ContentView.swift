//
//  ContentView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    // MARK: Properties
    
    var firedDBHelper: FireDBHelper = FireDBHelper.getInstance()
    var fireAuthHelper: FireAuthHelper = FireAuthHelper.getInstance()
    @ObservedObject var locationHelper = LocationHelper.getInstance()
    @State private var isLoggedIn: Bool = false
    @State private var rootView: RootViewState = .Login
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            
            switch rootView {
            case .Login:
                LoginView(rootView: $rootView)
                    .environmentObject(fireAuthHelper)
                    .environmentObject(firedDBHelper)
            case .Register:
                RegisterView(rootView: $rootView)
                    .environmentObject(fireAuthHelper)
                    .environmentObject(firedDBHelper)
            case .TabView:
                
                TabView {
                    
                    SessionListView()
                        .tabItem {
                            Image(systemName: "square.grid.2x2")
                            Text("Sessions")
                        }
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                    
                    FavouriteListView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Favourites")
                        }
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                    
                    PurchaseListView()
                        .tabItem {
                            Image(systemName: "dollarsign.circle.fill")
                            Text("Purchases")
                        }
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                    
                    ProfileView(rootView: $rootView)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                    
                }//: TabView
                .tint(.black)
                
            }//: SWITCH
        }
        .onAppear {
            setup()
        }
    }//: Body
}

#Preview {
    ContentView()
}

// MARK: ContentView extension

extension ContentView {
    
    // MARK: Methods
    
    private func setup() {
        SessionDataHelper().getSessionsData()
        rootView = Auth.auth().currentUser == nil ? .Login : .TabView
    }
    
}
