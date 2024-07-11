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
    
    @State private var userFavSessions: [Session] = []
    @State private var showAlert = false
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            Group {
                if userFavSessions.isEmpty {
                    Text("You don't have any sessions favourited...")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(userFavSessions, id: \.id) { session in
                            FavouriteItemView(session: session)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .onAppear {
                setup()
            }
            .onChange(of: fireDBHelper.userObj, { oldValue, newValue in
                filterUserFavsFromSessList()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Remove All")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Remove All Favorites"),
                    message: Text("Are you sure you want to remove all favorite sessions?"),
                    primaryButton: .destructive(Text("Remove All")) {
                        removeAllFavourites()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: FavouriteListView extension

extension FavouriteListView {
    
    // MARK: Methods
    
    private func setup() {
        filterUserFavsFromSessList()
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let session = userFavSessions[index]
            if fireDBHelper.userObj != nil {
                fireDBHelper.deleteSessionFromFav(with: session.id)
                userFavSessions.remove(at: index)
            }
        }
    }
    
    private func removeAllFavourites() {
        if !userFavSessions.isEmpty {
            guard fireDBHelper.userObj != nil else {
                print(#function, "FavouriteListView: Userobj is nil!")
                return
            }
            fireDBHelper.removeAllSessionsFromFav()
            userFavSessions.removeAll()
        }
    }
    
    private func filterUserFavsFromSessList() {
        guard let userObj = fireDBHelper.userObj else {
            print(#function, "FavouriteListView: Userobj is nil!")
            return
        }
        userFavSessions = sessionDataHelper.sessionList.filter { session in
            userObj.favorites.contains(session.id)
        }
    }
}

#Preview {
    FavouriteListView()
        .environmentObject(FireAuthHelper.getInstance())
        .environmentObject(FireDBHelper.getInstance())
        .environmentObject(SessionDataHelper.getInstance())
}
