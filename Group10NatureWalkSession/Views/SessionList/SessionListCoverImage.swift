//
//  SessionListCoverImage.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI

struct SessionListCoverImage: View {
    
    // MARK: Properties
    
    let coverImages: [CoverImage]
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    // MARK: Body
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(coverImages.indices, id: \.self) { index in
                Image(coverImages[index].name)
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            } //: FOREACH
        } //: TABVIEW
        .tabViewStyle(PageTabViewStyle())
        .frame(
            height: coverImageHeight
        )
        .listRowInsets(
            EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
        .padding(.bottom, 16)
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % coverImages.count
            }
        }
    }
}

#Preview {
    SessionListCoverImage(
        coverImages: [
            CoverImage(id: 1, name: "coverImage1")
        ]
    )
}

extension SessionListCoverImage {
    
    var coverImageHeight: CGFloat {
        (UIScreen.main.bounds.size.width) / 1.575
    }
    
}
