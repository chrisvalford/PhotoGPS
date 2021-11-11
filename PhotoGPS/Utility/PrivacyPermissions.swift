//
//  PrivacyPermissions.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import AVFoundation
import CoreLocation
import Foundation

enum PermissionState {
    case authorized
    case notDetermined
    case unauthorized
}

class PrivacyPermissions: ObservableObject {

    @Published var cameraPrivacy: PermissionState = .notDetermined
    @Published var locationPrivacy: PermissionState = .notDetermined

    static let shared = PrivacyPermissions()

    func askCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { authorized in
            if !authorized {
                self.cameraPrivacy = .unauthorized
            } else {
                self.cameraPrivacy = .authorized
            }
        }
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            cameraPrivacy = .notDetermined
        case .restricted:
            cameraPrivacy = .unauthorized
        case .denied:
            cameraPrivacy = .unauthorized
        case .authorized:
            break
        @unknown default:
            cameraPrivacy = .unauthorized
        }
    }

    func checkLocationPermission() {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .notDetermined:
            locationPrivacy = .notDetermined
        case .authorizedAlways, .authorizedWhenInUse:
            locationPrivacy = .authorized
        case .restricted:
            locationPrivacy = .unauthorized
        case .denied:
            locationPrivacy = .unauthorized
        @unknown default:
            locationPrivacy = .unauthorized
        }
    }

    func askLocationPermission() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }


}
