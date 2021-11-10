//
//  CameraControlsView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import Foundation

import SwiftUI

struct CameraControlsView: View {
    var captureButtonAction: (() -> Void)
    
    var body: some View {
        CaptureButtonView()
            .onTapGesture {
                captureButtonAction()
            }
    }
}
