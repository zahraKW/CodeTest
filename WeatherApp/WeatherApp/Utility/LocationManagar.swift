//
//  LocationManagar.swift
//  WeatherApp
//
//  Created by Mital Khandhar on 21/09/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    @Published var cordinate : CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            
            guard let currentLocation = currentLocation else {
                return
            }
            cordinate = currentLocation
        }
    }
}
