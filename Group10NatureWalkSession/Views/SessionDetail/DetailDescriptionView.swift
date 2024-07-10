//
//  SessionDetailDescriptionView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailDescriptionView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        Text(session.description)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
    }
}

#Preview {
    DetailDescriptionView(
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
