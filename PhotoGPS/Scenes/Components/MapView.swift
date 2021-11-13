//
//  MapView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import MapKit
import SwiftUI

struct PhotoPin: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {

    private var pins: [PhotoPin] {
        [PhotoPin(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))]
    }

    @Binding var item: GPSData

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.zoom, .pan], annotationItems: pins) { pin in
            MapMarker(coordinate: pin.coordinate, tint: .orange)
        }
    }
}
