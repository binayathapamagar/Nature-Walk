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
        session: Session(id: 0, name: "Test", description: "Test", starRating: 3.5, guideName: "Test", photos: [], pricingPerPerson: 3.4)
    )
}
