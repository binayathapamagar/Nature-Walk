//
//  CustomTextField.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
}
