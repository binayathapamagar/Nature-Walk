//
//  PurchaseListView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct PurchaseListView: View {
    
    // MARK: Properties
    
    @Binding var rootView: RootViewState
    @Binding var selectedTabIndex: Int
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper

    @State private var userPurchasedTickets: [Ticket] = []
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            Group {
                if userPurchasedTickets.isEmpty {
                    Text("You've yet to make any ticket purchases...")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(userPurchasedTickets, id: \.id) { ticket in
                                NavigationLink(
                                    destination: PurchaseTicketDetailView(ticket: ticket)
                                        .environmentObject(fireAuthHelper)
                                        .environmentObject(fireDBHelper)
                                        .environmentObject(sessionDataHelper)
                                ) {
                                    PurchaseItemView(ticket: ticket)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
            }
            .groupBoxStyle(DefaultGroupBoxStyle())
            .navigationTitle("Purchases")
            .onAppear {
                setup()
            }
            .onChange(of: fireDBHelper.userObj, { oldValue, newValue in
                if fireAuthHelper.user == nil {
                    userPurchasedTickets.removeAll()
                }
            })
        }
    }

    // MARK: Methods
    
    private func setup() {
        guard let userObj = fireDBHelper.userObj else {
            print(#function, "PurchaseListView: Userobj is nil!")
            return
        }
        userPurchasedTickets = userObj.purchasedTickets
    }
}

#Preview {
    PurchaseListView(
        rootView: .constant(.Profile),
        selectedTabIndex: .constant(0)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
    .environmentObject(SessionDataHelper.getInstance())
}
