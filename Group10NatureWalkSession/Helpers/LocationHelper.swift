//
//  LocationHelper.swift
//  Group10NatureWalkSession
//
//  Created by BINAYA THAPA MAGAR on 2024-07-10.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: Static properties
    
    private static var shared: LocationHelper?
    
    // MARK: Properties

    private let geoCoder = CLGeocoder()//Helps to perform forward and reverse geocoding
    let locationManager: CLLocationManager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?

    @Published var geoCoordinates: CLLocation = CLLocation()
    @Published var geoLat = 0.0
    @Published var geoLong = 0.0
    @Published var geoString = "Fetching...."
    @Published var geoAddress = "Fetching...."
    
    // MARK: Static methods
    
    static func getInstance() -> LocationHelper {
        if shared == nil {
            self.shared = LocationHelper()
        }
        return self.shared!
    }
    
    // MARK: Initializers
    
    private override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.checkPermission()
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: Methods
    
    func performForwardGecoding(address: String) {
     
        self.geoCoder.geocodeAddressString(address) { placeMarks, error in
            
            //CLPlacemark - array of any places(coordinates) that matches given address
            
            if let error {
                self.geoString = "Unable to obtain coordinates for given address: \(error)"
                print(#function, "Unable to obtain coordinates for given address: \(error)")
                return
            } else {
                if let place = placeMarks?.first {
                    let matchedLocation = place.location!
                    self.geoCoordinates = place.location!
                    self.geoCoordinates = matchedLocation
                    self.geoLat = matchedLocation.coordinate.latitude
                    self.geoLong = matchedLocation.coordinate.longitude
                    self.geoString = "Lat:\(matchedLocation.coordinate.latitude) | Long: \(matchedLocation.coordinate.longitude)"
                    print(#function, "Matched Location: \(matchedLocation.coordinate)")
                }
            }
            
        }
        
    }
    
    func performReverseGeocoding(location: CLLocation) {
        
        self.geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            
            if let error {
                self.geoAddress = "Unable to obtain address for given location: \(error)"
                self.geoAddress = "No matching address"
                print(#function, "Unable to obtain address for given location: \(error)")
                return
            } else {
                if let place = placeMarks?.first {
                    print(#function, "Matching place: \(place)")
                    let street = place.thoroughfare ?? "NA"
                    let city = place.subLocality ?? "NA"
                    let postalCode = place.postalCode ?? "NA"
                    let country = place.country ?? "NA"
                    let province = place.administrativeArea ?? "NA"
                    self.geoLat = location.coordinate.latitude
                    self.geoLong = location.coordinate.longitude
                    self.geoAddress = "\(street), \(city), \(postalCode), \(country), \(province)"
                    return
                }
            }
            
        }
        
    }

    private func checkPermission() {
        switch self.locationManager.authorizationStatus {
        case .denied:
            
            //Restrict location features or request permission
            self.requestPermission()
            print(#function, "Location authorization denied")
            
        case .notDetermined:
            
            //Authorization status is unknown, request permission
            print(#function, "Location access not determined")
            self.requestPermission()
            
        case .restricted:
            
            //Precise location not allowed by user
            print(#function, "Precise location not allowed by user")
            
        case .authorizedWhenInUse, .authorizedAlways:
            
            locationManager.startUpdatingLocation()
            //Location access allowed, start fetching device location and update if nedded
            print(#function, "Location access allowed...fetching device location")
            
        @unknown default:
            print(#function, "Unable to determine location authorization")
        }
    }
    
    func requestPermission() {
//        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
//        } else {
//            print(#function, "Location services are disabled on device.")
//        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Location authorization has changed: \(manager.authorizationStatus)")
        self.authorizationStatus = manager.authorizationStatus
        
        switch self.locationManager.authorizationStatus {
        case .denied, .notDetermined:
            locationManager.stopUpdatingLocation()
        case .restricted, .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            print(#function, "Last Location: \(locations.last!)")
            self.currentLocation = locations.last!
        } else {
            guard let firstLocation = locations.first else { return }
            print(#function, "Old Location: \(firstLocation)")
            self.currentLocation = firstLocation
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Unable to update the location: \(error)")
    }
    
}
