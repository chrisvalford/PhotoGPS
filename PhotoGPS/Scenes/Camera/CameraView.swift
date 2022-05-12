//
//  ContentView.swift
//  SwiftUIScanner
//
//  Created by Tim Owings on 11/3/19.
//  Copyright © 2019 Tim Owings. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    
    @ObservedObject private var headingService = HeadingService.shared
    @State private var cameraPrivacy = PrivacyPermissions.shared.cameraPrivacy
    @State private var locationPrivacy = PrivacyPermissions.shared.locationPrivacy
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var permissionsAlertIsVisible = false

    @State private var message: LocalizedStringKey = ""
    @State private var missingCameraPermission = false
    @State private var missingLocationPermission = false
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: { _ in }
    )
    
    var body: some View {
        ZStack {
            CustomCameraView(
                customCameraRepresentable: customCameraRepresentable,
                imageCompletion: { _ in
                }
            )
                .onAppear {
                    customCameraRepresentable.startRunningCaptureSession()
                }
                .onDisappear {
                    customCameraRepresentable.stopRunningCaptureSession()
                }
            VStack {
                HeadingView()
                Spacer()
                HStack {
                }.padding()
                LatLongView()
                    .allowsHitTesting(false) // Pass the tap to the lower view
            }
            if permissionsAlertIsVisible {
                CustomAlertView(mode: .failure, message: message, okText: "general.settings") { action in
                    print(action)
                    switch action {
                    case "general.ok":
                        //Open settings
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    default: // "dismiss"
                        permissionsAlertIsVisible = false
                    }
                }
            }
        }
        .accentColor(.orange)
        .navigationTitle("general.camera")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onAppear {
            // Camera
            switch cameraPrivacy {
            case .unauthorized:
                missingCameraPermission = true
            case .notDetermined:
                PrivacyPermissions.shared.askCameraPermission()
            default:
                permissionsAlertIsVisible = false
            }
            // Location services
            switch locationPrivacy {
            case .unauthorized:
                missingLocationPermission = true
            case .notDetermined:
                PrivacyPermissions.shared.askLocationPermission()
            default:
                permissionsAlertIsVisible = false
            }

            if missingCameraPermission && missingLocationPermission {
                message = "privacy.missing.camera.location"
                permissionsAlertIsVisible = true
            } else if missingCameraPermission {
                message = "privacy.missing.camera"
                permissionsAlertIsVisible = true
            } else if missingLocationPermission {
                message = "privacy.missing.location"
                permissionsAlertIsVisible = true
            }

        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
