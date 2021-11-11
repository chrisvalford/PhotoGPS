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
    @State private var imageCount = 0
    @State private var permissionsAlertIsVisible = false
    @State private var permissionsString: String = "You have not granted:"
    
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: { _ in }
    )
    
    var body: some View {
        ZStack {
            CustomCameraView(
                customCameraRepresentable: customCameraRepresentable,
                imageCompletion: { success in
                    if success == true {
                        self.imageCount += 1
                        print("Saved \(self.imageCount) positions")
                    }
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
                CustomAlertView(mode: .failure, text: permissionsString, okText: "Settings") { action in
                    print(action)
                    switch action {
                    case "ok":
                        //Open settings
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    default: // "dismiss"
                        permissionsAlertIsVisible = false
                    }
                }
            }
        }
        .accentColor(.orange)
        .navigationTitle("Camera")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onAppear {
            // Camera
            switch cameraPrivacy {
            case .unauthorized:
                permissionsString += "\nCamera access"
                permissionsAlertIsVisible = true
            case .notDetermined:
                PrivacyPermissions.shared.askCameraPermission()
            default:
                permissionsAlertIsVisible = false
            }
            // Location services
            switch locationPrivacy {
            case .unauthorized:
                permissionsString += "\nLocation updates"
                permissionsAlertIsVisible = true
            case .notDetermined:
                PrivacyPermissions.shared.askLocationPermission()
            default:
                permissionsAlertIsVisible = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
