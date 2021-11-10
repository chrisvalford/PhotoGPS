//
//  HistoryDetailView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 4/6/21.
//

import SwiftUI

struct HistoryDetailView: View {

    @State var item: GPSData
    
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
            MapView(item: $item)
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
