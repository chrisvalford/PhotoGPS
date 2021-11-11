//
//  EmptyHistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 11/11/21.
//

import SwiftUI

struct EmptyHistoryView: View {
    
    var body: some View {
        List {
            Text("No photos")
                .font(.title)
            HStack {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)

                Text("Tap the camera button and take a photo. The photo will appear in the list here.")
            }
            HStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("Tap the circle to select the photo data to export.")
            }
            HStack {
                Image(systemName: "square.and.arrow.up.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("Tap the share button to export.")
            }
            HStack {
                Image(systemName: "gearshape.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("Tap the settings button to change your preferences")
            }
        }
    }
}

struct EmptyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHistoryView()
    }
}
