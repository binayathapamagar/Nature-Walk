//
//  PurchaseTicketDetailView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-11.
//

import SwiftUI
import MapKit

struct PurchaseTicketDetailView: View {
    
    // MARK: Properties
    
    var ticket: Ticket
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var sessionDataHelper: SessionDataHelper
    
    @State private var session: Session?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.85429, longitude: -79.30764),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State private var mapAnnotations: [PurchaseMapAnnotation] = []
    
    // MARK: Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ticket Details")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Session Name
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Session Name:")
                            .font(.headline)
                        Text(session.name)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Date
                HStack(spacing: 8) {
                    Text("Hiking Date:")
                        .font(.headline)
                    Text("\(Date.convertDateString(ticket.date))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Number of Tickets
                HStack(spacing: 8) {
                    Text("Number of Tickets:")
                        .font(.headline)
                    Text("\(ticket.numberOfTickets)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Pricing Per Person
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Price per Person:")
                            .font(.headline)
                        Text("$\(session.pricingPerPerson, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Pricing Per Person
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Total:")
                            .font(.headline)
                        Text("$\(session.pricingPerPerson * Double(ticket.numberOfTickets), specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Guide Name
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Guide Name:")
                            .font(.headline)
                        Text(session.guideName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Guide Phone Number (assuming it's stored in session)
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Guide Phone:")
                            .font(.headline)
                        Text("+1 \(session.guidePhoneNum)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Description
                if let session = session {
                    Text("Description:")
                        .font(.headline)
                    Text(session.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Star Rating
                if let session = session {
                    HStack(spacing: 8) {
                        Text("Star Rating:")
                            .font(.headline)
                        Text("\(String(format: "%.1f", session.starRating))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("Where we're located")
                    .font(.headline)
                
                // Map View
                Map(coordinateRegion: $region, annotationItems: mapAnnotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            Text(annotation.title ?? "Unknown location")
                                .font(.caption)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                            Image(systemName: "mappin.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .frame(height: 400)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .onAppear {
                setup()
            }
        }
        .navigationTitle("Ticket Detail")
    }
    
    // MARK: Methods
    
    private func setup() {
        guard let session = sessionDataHelper.sessionList.first(where: { $0.id == ticket.sessionID }) else {
            print(#function, "Session is nil!")
            return
        }
        self.session = session
        setupMap()
    }
    
    private func setupMap() {
        guard let session = session else {
            print(#function, "Session is nil!")
            return
        }
        let latitude = session.latitude
        let longitude = session.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                // Construct the address string from the placemark
                var addressString = "Session: \(session.name)" + "\nAddress: "
                
                if let streetNumber = placemark.subThoroughfare {
                    addressString += streetNumber + " "
                }
                
                if let streetName = placemark.thoroughfare {
                    addressString += streetName + ", "
                }
                
                if let city = placemark.locality {
                    addressString += city + ", "
                }
                
                if let postalCode = placemark.postalCode {
                    addressString += postalCode + ", "
                }
                
                if let country = placemark.country {
                    addressString += country
                }
                
                self.mapAnnotations = [
                    PurchaseMapAnnotation(
                        coordinate: location.coordinate,
                        name: session.name,
                        title: addressString
                    )
                ]
            } else {
                self.mapAnnotations = [
                    PurchaseMapAnnotation(
                        coordinate: location.coordinate,
                        name: session.name,
                        title: "Location"
                    )
                ]
            }
        }
    }
    
}

#Preview {
    PurchaseTicketDetailView(
        ticket: Ticket(
            id: UUID().uuidString,
            sessionID: 1,
            sessionName: "Session",
            date: "23/07/2024", numberOfTickets: 4
        )
    )
}
