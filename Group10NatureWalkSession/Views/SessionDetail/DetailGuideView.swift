//
//  SessionDetailGuideView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailGuideView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        HStack {
            Text("Guide:")
                .font(.headline)
                .fontWeight(.bold)
            Text(session.guideName)
                .font(.subheadline)
        }
    }
}

#Preview {
    DetailGuideView(
        session: Session(
            id: 1,
            name: "Test",
            description: "Test",
            starRating: 4,
            guideName: "John",
            photos: [
                SessionCoverImage(id: 1, name: "sessionOneA")
            ],
            pricingPerPerson: 9.99,
            date: "2024-08-22T11:30:00")
    )
}
