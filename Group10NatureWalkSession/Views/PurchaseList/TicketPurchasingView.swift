//
//  PurchaseTicketView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import SwiftUI

struct TicketPurchasingView: View {
    
    // MARK: Properties
    
    let session: Session
    
    @Binding var ticketQuantity: Int
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper
    @Environment(\.dismiss) private var dismiss
    
    var dismissAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Purchase Tickets")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Session: \(session.name)")
                .font(.headline)
            
            Stepper("Quantity: \(ticketQuantity)", value: $ticketQuantity, in: 1...10)
            
            Button(action: {
                purchaseTickets()
            }) {
                Text("Purchase")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

extension TicketPurchasingView {
    
    // MARK: Methods
    
    private func purchaseTickets() {
        print("Purchase \(ticketQuantity) tickets for session: \(session.name)")
        fireDBHelper.purchaseSessionTicket(with: session, and: ticketQuantity)
        dismissAction()
    }
    
}

#Preview {
    TicketPurchasingView(
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
            
        ),
        ticketQuantity: .constant(1),
        dismissAction: {}
    )
    .environmentObject(FireAuthHelper.getInstance())
    .environmentObject(FireDBHelper.getInstance())
    .environmentObject(SessionDataHelper.getInstance())
}
