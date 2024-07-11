//
//  SessionListView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI

struct SessionListView: View {
    
    // MARK: Properties
    
    @Binding var rootView: RootViewState
    @Binding var selectedTabIndex: Int
        
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper
        
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                SessionListCoverImage(coverImages: sessionDataHelper.homeCoverImages)
                    .listRowSeparator(.hidden)

                Text("Sessions Near You")
                    .font(.title2)
                    .fontWeight(.heavy)

                ForEach(sessionDataHelper.sessionList) { session in
                    NavigationLink(
                        destination: SessionDetailView(
                            session: session,
                            rootView: $rootView,
                            selectedTabIndex: $selectedTabIndex
                        )
                        .environmentObject(fireAuthHelper)
                        .environmentObject(fireDBHelper)
                        .environmentObject(sessionDataHelper)
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
                print(#function, "LOG: SessionListView OnAppear")
                if sessionDataHelper.sessionList.isEmpty || sessionDataHelper.homeCoverImages.isEmpty {
                    sessionDataHelper.getSessionsData()
                }
            }
            .navigationTitle("Toronto Nature Walk")
            .tint(.black)
        }//: NavigationStack
    }//: Body
}

// MARK: Preview

#Preview {
    SessionListView(
        rootView: .constant(.Profile),
        selectedTabIndex: .constant(0)
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
    .environmentObject(SessionDataHelper.getInstance())
}
