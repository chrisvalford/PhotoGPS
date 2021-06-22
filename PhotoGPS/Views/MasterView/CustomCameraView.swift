//
//  CustomCameraView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI

struct CustomCameraView: View {
    var customCameraRepresentable: CustomCameraRepresentable
    var imageCompletion: ((Bool) -> Void)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                cameraView(frame:  UIScreen.main.bounds)
                
//                HStack {
//                    Spacer()
//                    CameraControlsView(captureButtonAction: { [weak customCameraRepresentable] in
//                        customCameraRepresentable?.takePhoto()
//                    })
//                    .padding()
//                }
            }
        }
    }
    
    private func cameraView(frame: CGRect) -> CustomCameraRepresentable {
        customCameraRepresentable.cameraFrame = frame
        customCameraRepresentable.imageCompletion = imageCompletion
        return customCameraRepresentable
    }
}

