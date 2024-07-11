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
            starRating: 4,
            guideName: "John",
            photos: [
                SessionCoverImage(id: 1, name: "sessionOneA")
            ],
            pricingPerPerson: 9.99, date: "2024-08-22T11:30:00")
    )
}
