//
//  SessionDetailRatingsView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailRatingsView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(session.starRating) ? "star.fill" : "star")
                    .foregroundColor(index < Int(session.starRating) ? .yellow : .gray)
            }
            Text("(\(String(format: "%.1f", session.starRating)))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    DetailRatingsView(
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
            
        )
    )
}
