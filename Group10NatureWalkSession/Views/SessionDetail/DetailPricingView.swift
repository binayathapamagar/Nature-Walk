//
//  SessionDetailPricingView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailPricingView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        HStack {
            Text("Price per person:")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("$\(String(format: "%.2f", session.pricingPerPerson))")
                .font(.subheadline)
        }
    }
}

#Preview {
    DetailPricingView(
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
