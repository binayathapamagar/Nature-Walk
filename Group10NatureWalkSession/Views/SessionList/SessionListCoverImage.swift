//
//  SessionListCoverImage.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI
import Combine

struct SessionListCoverImage: View {
    
    // MARK: Properties
    
    let coverImages: [CoverImage]
    @State private var currentIndex = 0
    @State private var timer: AnyCancellable?
    
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
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: Methods
    
    private func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % coverImages.count
                }
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

extension SessionListCoverImage {
    
    var coverImageHeight: CGFloat {
        (UIScreen.main.bounds.size.width) / 1.575
    }
    
}

#Preview {
    SessionListCoverImage(
        coverImages: [
            CoverImage(id: 1, name: "coverImage1"),
            CoverImage(id: 2, name: "coverImage2"),
        ]
    )
}
