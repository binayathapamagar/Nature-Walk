//
//  FavouriteItemView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import SwiftUI

struct FavouriteItemView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        HStack {
            Image(session.photos[0].name)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text(session.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(session.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Text("\(session.pricingPerPerson, specifier: "%.2f")$")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 10)
    }
    
}

#Preview {
    FavouriteItemView(
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
