//
//  UserDefaults+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import CoreLocation
import Foundation

extension UserDefaults {
    
    var currentLocation: CLLocation {
        get { return CLLocation(latitude: latitude ?? 90, longitude: longitude ?? 0) } // default value is North Pole (lat: 90, long: 0)
        set { latitude = newValue.coordinate.latitude
            longitude = newValue.coordinate.longitude }
    }

//    var showOnboarding: Bool {
//        get {
//            if let _ = object(forKey: #function) {
//                return bool(forKey: #function)
//            }
//            return true
//        }
//        set { set(newValue, forKey: #function) }
//    }

    private var latitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }

    private var longitude: Double? {
        get {
            if let _ = object(forKey: #function) {
                return double(forKey: #function)
            }
            return nil
        }
        set { set(newValue, forKey: #function) }
    }


}
