//
//  PurchaseItemView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import SwiftUI

struct PurchaseItemView: View {
    
    // MARK: Properties
    
    var ticket: Ticket
    
    // MARK: Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ticket.sessionName)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\(ticket.numberOfTickets) tickets purchased")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Walk date:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(Date.convertDateString(ticket.date))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading) // Align content to leading edge
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.systemGray6))
        )
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    PurchaseItemView(
        ticket: Ticket(
            id: UUID().uuidString,
            sessionID: 1,
            sessionName: "Deez Nuts",
            date: "23/07/2024",
            numberOfTickets: 5)
    )
}
