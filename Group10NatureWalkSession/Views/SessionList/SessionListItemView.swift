//
//  SessionListItemView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-22.
//

import SwiftUI

struct SessionListItemView: View {
    
    // MARK: Properties
    
    let session: Session
    
    // MARK: Body
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            Image(session.photos[0].name)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                        
            VStack(alignment:.leading, spacing: 8) {
                
                Text(session.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Guide: \(session.guideName)")
                    .font(.footnote)
                    .padding(.trailing, 8)
                
                Text("Price per person: $\(session.pricingPerPerson, specifier: "%.2f")")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 8)
                
                Text(Date.convertDateString(session.date))
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 8)
                
            }//: VSTACK
            
            Spacer()
            
        }//: HSTACK
    }
}

#Preview {
    SessionListItemView(
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
