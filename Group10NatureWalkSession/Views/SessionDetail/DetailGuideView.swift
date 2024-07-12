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
        VStack(spacing: 4) {
            HStack {
                Text("Guide name:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(session.guideName)
                    .font(.subheadline)
            }
            
            HStack {
                Text("Guide phone number:")
                    .font(.headline)
                    .fontWeight(.bold)
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + session.guidePhoneNum
                    guard let url = URL(string: formattedString) else { return }
                    
                    //You may need to import UIKit framework to use UIApplication package
                    UIApplication.shared.open(url)
                }) {
                    Text(session.guidePhoneNum)
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    DetailGuideView(
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
