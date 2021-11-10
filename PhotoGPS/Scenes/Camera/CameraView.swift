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
    @State private var imageCount = 0
    
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
        }
        .accentColor(.orange)
        .navigationTitle("Camera")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
