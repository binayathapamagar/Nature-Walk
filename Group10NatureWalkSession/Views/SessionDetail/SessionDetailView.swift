//
//  SessionDetailView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct SessionDetailView: View {
    
    // MARK: Properties
    
    let session: Session

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
                        
                    }) {
                        HStack {
                            Image(
                                systemName: "heart"
                            )
                                .foregroundColor(
                                    .gray
                                )
                            Text("Favorite")
                                .font(.subheadline)
                                .foregroundColor(
                                    .gray
                                )
                        }
                        .padding(8)
                        .background(
                            Color(
                                UIColor.systemGray6
                            )
                        )
                        .cornerRadius(8)
                    }
                    
                    // Share Button
                    Button(action: {
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
        }
        .scrollIndicators(.hidden)
        .onAppear {
            
        }
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
            pricingPerPerson: 9.99)
    )
}
