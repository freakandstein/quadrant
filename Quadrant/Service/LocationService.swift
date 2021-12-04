//
//  LocationService.swift
//  Quadrant
//
//  Created by Satrio Wicaksono on 04/12/21.
//

import Foundation
import MapKit

protocol LocationProtocol: AnyObject {
    func getLatitude() -> Double
    func getLongitude() -> Double
    func requestLocation()
}

class LocationProvider: NSObject, LocationProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    
    override init () {
        super.init()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestLocation()
            guard let currentLocation = locationManager.location else { return }
            location = currentLocation
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
        }
    }
    
    func getLatitude() -> Double {
        return location?.coordinate.latitude ?? .zero
    }
    
    func getLongitude() -> Double {
        return location?.coordinate.longitude ?? .zero
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        location = latestLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
}

class LocationService {
    static let shared: LocationProtocol = LocationProvider()
}
