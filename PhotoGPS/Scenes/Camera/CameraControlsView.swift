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
                let haptic = UIImpactFeedbackGenerator(style: .heavy)
                haptic.impactOccurred(intensity: 0.5)
                captureButtonAction()
            }
    }
}
