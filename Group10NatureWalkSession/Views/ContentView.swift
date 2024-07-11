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
    
    private var firedDBHelper: FireDBHelper = FireDBHelper.getInstance()
    private var fireAuthHelper: FireAuthHelper = FireAuthHelper.getInstance()
    private var sessionDataHelper = SessionDataHelper.getInstance()
    
    @StateObject var locationHelper = LocationHelper.getInstance()
    
    @State private var isLoggedIn: Bool = false
    @State private var rootView: RootViewState = .Login
    @State private var selectedTabIndex: Int = 0
    @State private var showLoginActionSheet = false
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            
            TabView(selection: $selectedTabIndex) {
                
                // Session List View
                SessionListView(
                    rootView: $rootView,
                    selectedTabIndex: $selectedTabIndex
                )
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Sessions")
                }
                .environmentObject(fireAuthHelper)
                .environmentObject(firedDBHelper)
                .environmentObject(sessionDataHelper)
                .tag(0)
                
                // Favorites List View
                FavouriteListView(
                    rootView: $rootView,
                    selectedTabIndex: $selectedTabIndex
                )
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                }
                .environmentObject(fireAuthHelper)
                .environmentObject(firedDBHelper)
                .environmentObject(sessionDataHelper)
                .onAppear {
                    checkUserLogin()
                }
                .tag(1)
                
                // Purchases List View
                PurchaseListView()
                    .tabItem {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Purchases")
                    }
                    .environmentObject(fireAuthHelper)
                    .environmentObject(firedDBHelper)
                    .environmentObject(sessionDataHelper)
                    .onAppear {
                        checkUserLogin()
                    }
                    .tag(2)
                
                // Profile View
                switch rootView {
                case .Login:
                    LoginView(rootView: $rootView)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                        .tag(3)
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                case .Register:
                    RegisterView(rootView: $rootView)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                        .tag(3)
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                case .Profile:
                    ProfileView(rootView: $rootView)
                        .tabItem {
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }
                        .tag(3)
                        .environmentObject(fireAuthHelper)
                        .environmentObject(firedDBHelper)
                }
                
            }//: TabView
            .tint(.black)
            
        }
        .onAppear {
            setup()
        }
        .actionSheet(isPresented: $showLoginActionSheet) {
            ActionSheet(
                title: Text("Login Required"),
                message: Text("Please login to access this feature."),
                buttons: [
                    .default(Text("Login")) {
                        openLoginPage()
                    },
                    .cancel()
                ]
            )
        }
    }//: Body
    
}

// MARK: ContentView Extension

extension ContentView {
    
    // MARK: Methods
    
    private func setup() {
        rootView = Auth.auth().currentUser == nil ? .Login : .Profile
        if Auth.auth().currentUser != nil {
            firedDBHelper.fetchUserFromDB()
        }
        SessionDataHelper().getSessionsData()
    }
    
    private func checkUserLogin() {
        if Auth.auth().currentUser == nil {
            showLoginActionSheet = true
        }
    }
    
    private func openLoginPage() {
        rootView = .Login
        selectedTabIndex = 3
    }
    
}

#Preview {
    ContentView()
}
