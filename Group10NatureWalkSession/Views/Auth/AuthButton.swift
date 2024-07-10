//
//  SignUpButton.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import SwiftUI

struct AuthButton: View {
    
    // MARK: Properties
    
    var title: String
    var color: Color
    
    // MARK: Body
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
    }
}

#Preview {
    AuthButton(title: "Register", color: Color.blue)
}
