//
//  SessionListView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI

struct SessionListView: View {
    
    // MARK: Properties
    
    @ObservedObject private var sessionApiHelper = SessionDataHelper()
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                SessionListCoverImage(coverImages: sessionApiHelper.homeCoverImages)
                    .listRowSeparator(.hidden)

                Text("Hikes Near You")
                    .font(.title2)
                    .fontWeight(.heavy)

                ForEach(sessionApiHelper.sessionList) { session in
                    NavigationLink(
                        destination: SessionDetailView(session: session)
                    ) {
                        SessionListItemView(session: session)
                    }
                }
                .listRowSeparator(.hidden)
                
            }//:LIST
            .listStyle(
                PlainListStyle()
            )
            .scrollIndicators(.hidden)
            .onAppear {
                sessionApiHelper.getSessionsData()
            }
            .navigationTitle("Toronto Nature Walk")
            .tint(.black)
        }//: NavigationStack
    }//: Body
}

// MARK: Preview

#Preview {
    SessionListView()
}
