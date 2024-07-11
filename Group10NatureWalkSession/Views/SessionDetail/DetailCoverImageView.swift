//
//  SessionDetailCoverImageView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct DetailCoverImageView: View {
    
    // MARK: Properties
    
    let session: Session
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    
    // MARK: Body
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(session.photos.indices, id: \.self) { index in
                Image(session.photos[index].name)
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            } //: FOREACH
        } //: TABVIEW
        .tabViewStyle(PageTabViewStyle())
        .frame(height: (UIScreen.main.bounds.size.width) / 1.575)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % session.photos.count
            }
        }
    }
}

#Preview {
    DetailCoverImageView(
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
