//
//  SessionDetailView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI
import FirebaseAuth

struct SessionDetailView: View {
    
    // MARK: Properties
    
    let session: Session
    
    @Binding var rootView: RootViewState
    @Binding var selectedTabIndex: Int
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper
    @Environment(\.dismiss) private var dismiss
    
    @State private var showLoginActionSheet = false
    @State private var isSessionInFavorites = false
    @State private var isLoading = false // For activity indicator
        
    // MARK: Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                
                DetailCoverImageView(session: session)
                
                DetailTitleView(session: session)
                
                DetailDescriptionView(session: session)
                
                DetailRatingsView(session: session)
                
                DetailGuideView(session: session)
                
                DetailPricingView(session: session)
                
                // Favorites and Share buttons
                HStack {
                    // Favorites Button
                    Button(action: {
                        favButtonTapped()
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: .gray)
                                    )
                            } else {
                                Image(systemName: isSessionInFavorites ? "heart.fill" : "heart")
                                    .foregroundColor(isSessionInFavorites ? .red : .gray)
                                Text("Favorite")
                                    .font(.subheadline)
                                    .foregroundColor(isSessionInFavorites ? .red : .gray)
                            }
                        }
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Share Button
                    Button(action: {
                        // Add your share functionality here
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                            Text("Share")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 10)
                
            }
            .navigationTitle("Learn about the \(session.name)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setup()
            }
            .onChange(of: fireDBHelper.userObj) { oldUserObj, newUserObj in
                updateFavButton(with: newUserObj)
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
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: SessionDetailView extension

extension SessionDetailView {
    
    // MARK: Methods
    
    private func setup() {
        if Auth.auth().currentUser != nil {
            updateFavButton(with: fireDBHelper.userObj!)
        } else {
            print(#function, "User is not logged in")
        }
    }
    
    private func favButtonTapped() {
        isLoading = true
        if Auth.auth().currentUser != nil {
            sessionInUserFavs()
            ? fireDBHelper.deleteSessionFromFav(with: session.id)
            : fireDBHelper.addSessionIdToFavs(with: session.id)
        } else {
            showLoginActionSheet = true
        }
    }
    
    private func openLoginPage() {
        rootView = .Login
        selectedTabIndex = 3
        dismiss()
    }
    
    private func updateFavButton(with newUserObj: UserObj?) {
        isLoading = false
        if sessionInUserFavs() {
            isSessionInFavorites = true
        } else {
            isSessionInFavorites = false
        }
    }
    
    private func sessionInUserFavs() -> Bool {
        guard let userObj = fireDBHelper.userObj else {
            print(#function, "User obj is nil.")
            return false
        }
        return userObj.favorites.contains(where: { $0 == session.id })
    }
    
}

#Preview {
    SessionDetailView(
        session: Session(
            id: 1,
            name: "Test",
            description: "Test",
            starRating: 4,
            guideName: "John",
            photos: [
                SessionCoverImage(id: 1, name: "sessionOneA")
            ],
            pricingPerPerson: 9.99
        ),
        rootView: .constant(.Login),
        selectedTabIndex: .constant(0)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
    .environmentObject(SessionDataHelper.getInstance())
}
