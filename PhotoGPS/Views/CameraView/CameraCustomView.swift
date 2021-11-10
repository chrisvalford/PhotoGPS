//
//  CameraCustomView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI

struct CameraCustomView: View {
    var customCameraRepresentable: CameraCustomRepresentable
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
    
    private func cameraView(frame: CGRect) -> CameraCustomRepresentable {
        customCameraRepresentable.cameraFrame = frame
        customCameraRepresentable.imageCompletion = imageCompletion
        return customCameraRepresentable
    }
}

