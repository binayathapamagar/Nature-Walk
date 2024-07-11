//
//  AuthHeadingView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import SwiftUI

struct AuthHeadingView: View {
    
    // MARK: Properties
    
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(description)
                .font(.subheadline)
                .fontWeight(.regular)
        }
    }
}

#Preview {
    AuthHeadingView(
        title: "Sign Up",
        description: "Join us and others from Toronto to rejuvenate by walking"
    )
}
