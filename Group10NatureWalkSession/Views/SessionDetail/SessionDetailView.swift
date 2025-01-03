//
//  SessionDetailView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

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
    @State private var isLoading = false
    @State private var showTicketPurchaseModal = false
    @State private var ticketQuantity = 1
    @State private var sessionAlrPurchsed = false
    @State private var addressString = ""
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
    let geocoder = CLGeocoder()
        
    // MARK: Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    
                    DetailCoverImageView(session: session)
                    
                    DetailTitleView(session: session)
                    
                    DetailDescriptionView(session: session)
                    
                    Text("Happening on \(Date.convertDateString(session.date))!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    NavigationLink(
                        destination: MapView(latitude: session.latitude, longitude: session.longitude)
                            .ignoresSafeArea(.all)
                    ) {
                        Text("Address: \(addressString)!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    DetailRatingsView(session: session)
                    
                    DetailGuideView(session: session)
                    
                    DetailPricingView(session: session)
                    
                    // Favorites, Share, and Purchase buttons
                    HStack(spacing: 10) {
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
                                    Image(
                                        systemName: isSessionInFavorites ? "heart.fill" : "heart"
                                    )
                                    .foregroundColor(
                                        isSessionInFavorites ? .red : .gray
                                    )
                                    Text("Favorite")
                                        .font(.subheadline)
                                        .foregroundColor(
                                            isSessionInFavorites ? .red : .gray
                                        )
                                }
                            }
                            .padding(8)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        // Share Button
                        Button(action: {
                            shareSession()
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
                    
                    HStack {
                        
                        // Purchase Button
                        Button(action: {
                            purchaseButtonTapped()
                        }) {
                            HStack {
                                Image(
                                    systemName: sessionAlrPurchsed ? "cart.fill" : "cart"
                                )
                                .foregroundColor(
                                    sessionAlrPurchsed ? .green : .gray
                                )
                                Text("Purchase")
                                    .font(.subheadline)
                                    .foregroundColor(
                                        sessionAlrPurchsed ? .green : .gray
                                    )
                            }
                            .padding(8)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        }
                        .sheet(isPresented: $showTicketPurchaseModal) {
                            TicketPurchasingView(
                                session: session,
                                ticketQuantity: $ticketQuantity,
                                dismissAction: {
                                    showTicketPurchaseModal = false
                                }
                            )
                            .environmentObject(fireAuthHelper)
                            .environmentObject(fireDBHelper)
                            .environmentObject(sessionDataHelper)
                        }
                        
                        // Map Button
                        Button(action: {
                            shareSession()
                        }) {
                            NavigationLink(
                                destination: MapView(
                                    latitude: session.latitude,
                                    longitude: session.longitude
                                )
                            ) {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Map")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                .padding(8)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                    }
                    
                }
                .navigationTitle("Learn about the \(session.name)")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    setup()
                }
                .onChange(of: fireDBHelper.userObj) { oldUserObj, newUserObj in
                    updateButtons()
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

}

// MARK: General Methods extension

extension SessionDetailView {
        
    private func setup() {
        if Auth.auth().currentUser != nil {
            updateFavButton()
            updatePurchaseButton()
            geocodeAddress()
        } else {
            print(#function, "User is not logged in")
            geocodeAddress()
        }
    }
    
    private func openLoginPage() {
        rootView = .Login
        selectedTabIndex = 3
        dismiss()
    }
    
    private func updateButtons() {
        updateFavButton()
        updatePurchaseButton()
    }
    
    private func shareSession() {
        let activityViewController = UIActivityViewController(activityItems: ["\(session.name) - Price: $\(session.pricingPerPerson)"], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    private func geocodeAddress() {
        let location = CLLocation(latitude: session.latitude, longitude: session.longitude)
        geocoder.reverseGeocodeLocation(location) { placeMarks, error in
            
            if let error {
                print(#function, "Unable to obtain address for given location: \(error)")
                return
            } else {
                if let place = placeMarks?.first {
                    print(#function, "Matching place: \(place)")
                    let street = place.thoroughfare ?? "NA"
                    let city = place.subLocality ?? "NA"
                    let postalCode = place.postalCode ?? "NA"
                    let country = place.country ?? "NA"
                    let province = place.administrativeArea ?? "NA"
                    self.addressString = "\(street), \(city), \(postalCode), \(country), \(province)"
                    return
                }
            }
            
        }
    }
    
}

// MARK: Fav Button methods

extension SessionDetailView {
    
    private func favButtonTapped() {
        isLoading = true
        if Auth.auth().currentUser != nil {
            sessionInUserFavs()
            ? fireDBHelper.deleteSessionFromFav(with: session.id)
            : fireDBHelper.addSessionIdToFavs(with: session.id)
        } else {
            isLoading = false
            showLoginActionSheet = true
        }
    }
    
    private func updateFavButton() {
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

// MARK: Purchase Button Methods

extension SessionDetailView {
    
    private func purchaseButtonTapped() {
        if Auth.auth().currentUser != nil {
            if sessionAlrPurchsed {
                return
            }
            showTicketPurchaseModal = true
        } else {
            showLoginActionSheet = true
        }
    }
    
    private func updatePurchaseButton() {
        if sessionAlrPurchased() {
            sessionAlrPurchsed = true
        } else {
            sessionAlrPurchsed = false
        }
    }
    
    private func sessionAlrPurchased() -> Bool {
        guard let userObj = fireDBHelper.userObj else {
            print(#function, "User obj is nil.")
            return false
        }
        return userObj.purchasedTickets.contains(where: { $0.sessionID == session.id })
    }
    
}

#Preview {
    SessionDetailView(
        session: Session(
            id: 1,
            name: "Test",
            description: "Test",
            starRating: 2.5,
            guideName: "Test",
            guidePhoneNum: "4357718231",
            photos: [SessionCoverImage(id: 0, name: "coverImage1")],
            pricingPerPerson: 1.1,
            date: "2024-08-22T11:30:00",
            latitude: 43.7688,
            longitude: -79.4130
            
        ),
        rootView: .constant(.Login),
        selectedTabIndex: .constant(0)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
    .environmentObject(SessionDataHelper.getInstance())
}
