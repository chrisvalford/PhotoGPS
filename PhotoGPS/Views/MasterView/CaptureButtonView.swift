//
//  CaptureButtonView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI

struct CaptureButtonView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Image(systemName: "camera")
            .foregroundColor(.white)
            .font(.headline)
            .padding(14)
            .background(Color("ArrowColor"))
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .clipShape(Circle())
    }
}
