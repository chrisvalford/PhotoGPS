//
//  HistoryDetailView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 4/6/21.
//

import SwiftUI
import MapKit

struct HistoryDetailView: View {
    @State var item: GPSData {
        didSet {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }

    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                               span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Latitude")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.latitude.formatLatitude())")
                }
                HStack {
                    Text("Longitude")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.longitude.formatLongitude())")
                }
            }
            Section {
                HStack {
                    Text("Heading")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.trueHeading.formatHeading()) º (T)")
                    Text("\(item.magneticHeading.formatHeading()) º (M)")
                }
                HStack {
                    Text("Elevation")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.elevation) m")
                }
                HStack {
                    Text("Accuracy")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.accuracy)")
                }
            }
            //               Map(coordinateRegion: $region, showsUserLocation: false, userTrackingMode: .constant(.follow))
            //                            .frame(width: 400, height: 300)
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.zoom])
                .frame(width: 400, height: 300)
        }
        .navigationTitle("\(item.saved?.titleDate() ?? "")")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let data = GPSData()
        HistoryDetailView(item: data)
    }
}
