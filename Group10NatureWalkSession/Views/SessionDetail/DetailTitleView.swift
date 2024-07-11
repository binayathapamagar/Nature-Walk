//
//  DetailTitleView.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-06-23.
//

import SwiftUI
import CoreLocation

struct DetailTitleView: View {
    
    // MARK: Properties
    
    let session: Session
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
    let geocoder = CLGeocoder()
    
    // MARK: Body
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: MapView(
                    latitude: latitude,
                    longitude: longitude
                )
            ) {
                Text(session.name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .foregroundColor(.primary)
                    .background(
                        Color.black
                            .frame(height: 6)
                            .offset(y: 24)
                    )
            }
        }
        .onAppear {
            geocodeAddress()
        }
    }
    
    // Function to perform geocoding
    private func geocodeAddress() {
        geocoder.geocodeAddressString(session.name) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                // Optionally update other state variables with placemark details
                // Example:
                // self.buildingCode = placemark.subThoroughfare ?? ""
                // self.licensePlate = placemark.administrativeArea ?? ""
            }
        }
    }
}

#Preview {
    DetailTitleView(
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
