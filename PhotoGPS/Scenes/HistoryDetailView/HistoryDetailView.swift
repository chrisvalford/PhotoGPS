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
        GeometryReader { geometry in
            Form {
                Section {
                    HStack {
                        Text("location.latitude")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(item.latitude.formatLatitude())")
                    }
                    HStack {
                        Text("location.longitude")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(item.longitude.formatLongitude())")
                    }
                }
                Section {
                    HStack {
                        Text("location.heading")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(item.trueHeading.formatHeading()) º (T)")
                        Text("\(item.magneticHeading.formatHeading()) º (M)")
                    }
                    HStack {
                        Text("location.elevation")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(item.elevation.roundedDecimal(to: 1)) m")
                    }
                    HStack {
                        Text("location.accuracy")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(item.accuracy.roundedDecimal(to: 1))")
                    }
                }
                MapView(item: $item)
                    .frame(height: geometry.size.width * 0.8)
            }
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
