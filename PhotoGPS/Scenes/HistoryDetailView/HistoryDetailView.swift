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
                Text("Taken")
                Text("\(localizedDate(item.saved))")
            }
            Section {
                Text("Latitude")
                Text("\(formatLatitude(from: item.latitude))")
                //Text("\(item.latitude)")
                Text("Longitude")
                Text("\(formatLongitude(from: item.longitude))")
                //Text("\(item.longitude)")
            }
            Section {
                Text("Heading")
                Text("\(formatHeading(from: item.trueHeading)) º (T)")
                Text("\(formatHeading(from: item.magneticHeading)) º (M)")
                Text("Elevation")
                Text("\(item.elevation) m")
                Text("Accuracy")
                Text("\(item.accuracy)")
            }
            //               Map(coordinateRegion: $region, showsUserLocation: false, userTrackingMode: .constant(.follow))
            //                            .frame(width: 400, height: 300)
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.zoom])
                .frame(width: 400, height: 300)
        }
    }

    func localizedDate(_ date: Date?) -> String {
        guard let date = date else { return "Missing!" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        return formatter.string(from: date)
    }

    func formatLongitude(from: Double) -> String {
        let lat = decimalDegrees(from: from)
        var direction = "W"
        if (lat.0 >= 0 && lat.1 >= 0 && lat.2 > 0) && lat.0 < 180 {
            direction = "E"
        }
        return "\(lat.0)º \(lat.1)' \(lat.2)\" \(direction)"
    }

    func formatLatitude(from: Double) -> String {
        let lng = decimalDegrees(from: from)
        var direction = "S"
        if (lng.0 >= 0 && lng.1 >= 0 && lng.2 > 0) && lng.0 < 90 {
            direction = "N"
        }
        return "\(lng.0)º \(lng.1)' \(lng.2)\" \(direction)"
    }

    func formatHeading(from: Double) -> String {
        return String(format: "%.1f", round(from * 10) / 10.0)
    }

    func decimalDegrees(from: Double) -> (Int, Int, Double) {
        let d = Int(from)
        let m = Int((from - Double(d)) * 60)
        let s = (from - Double(d) - Double(m) / 60) * 3600
        let rs = round(s * 10) / 10.0
        return (d, m, rs)
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let data = GPSData()
        HistoryDetailView(item: data)
    }
}
