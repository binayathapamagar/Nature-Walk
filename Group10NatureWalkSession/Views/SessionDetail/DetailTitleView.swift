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
        VStack {
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
    
}

#Preview {
    DetailTitleView(
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
