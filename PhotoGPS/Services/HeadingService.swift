//
//  LocationEngine.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 26/5/21.
//

import UIKit
import CoreLocation

class HeadingService: NSObject, ObservableObject {
    
    static let shared = PhotoGPS.HeadingService()
    
    @Published var headingText: String = ""
    @Published var latitudeText: String = ""
    @Published var longitudeText: String = ""
    @Published var heading: Double = 0
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var rotation: Double = 0
    @Published var accuracy: Double = 0
    @Published var elevation: Double = 0
    
    var locationManager: CLLocationManager
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    var yourLocation: CLLocation {
        get { return UserDefaults.standard.currentLocation }
        set { UserDefaults.standard.currentLocation = newValue }
    }
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        super.init()
        locationManager.delegate = self
    }
    
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
                switch interfaceOrientation {
                case .landscapeLeft:  return 90
                case .landscapeRight: return -90
                case .portrait, .unknown: return 0
                case .portraitUpsideDown: return isFaceDown ? 180 : -180
                @unknown default:
                    return 0
                }
            }
            return 0
        }()
        return adjAngle
    }
    
    func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
        let heading: CGFloat = {
            let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
            switch UIDevice.current.orientation {
            case .faceDown: return -originalHeading
            default: return originalHeading
            }
        }()
        return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
    }
}

extension HeadingService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        latitudeText = String(format: "%f", userLocation.coordinate.latitude)
        longitudeText = String(format: "%f", userLocation.coordinate.longitude)
        accuracy = userLocation.horizontalAccuracy // verticalAccuracy - keep worst value
        elevation = userLocation.altitude
    }
    
    func HeadingService(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.rotation = Double(Int(newHeading.trueHeading * -1))
        self.heading = newHeading.trueHeading
        self.headingText = String(format: "%f", self.computeNewAngle(with: CGFloat(newHeading.trueHeading)).radiansToDegrees * -1)
    }
}
