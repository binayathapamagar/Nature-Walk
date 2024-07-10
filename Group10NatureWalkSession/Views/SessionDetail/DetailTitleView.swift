//
//  DetailTitleView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailTitleView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        Text(session.name)
            .font(.title)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
            .foregroundColor(.primary)
            .background(
                Color.black
                    .frame(height: 6)
                    .offset(y: 24)
            )
    }
}

#Preview {
    DetailTitleView(
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
