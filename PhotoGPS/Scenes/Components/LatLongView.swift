//
//  LatLongView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import SwiftUI

struct LatLongView: View {

    @ObservedObject private var headingService = HeadingService.shared
    
    var body: some View {
        HStack {
            VStack {
                Text("location.latitude")
                    .font(.body)
                    .fontWeight(.bold)
                    .frame(maxWidth: 100, alignment: .trailing)
                Text("location.longitude")
                    .font(.body)
                    .fontWeight(.bold)
                    .frame(maxWidth: 100, alignment: .trailing)
            }
            VStack {
                Text(headingService.latitudeText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(headingService.longitudeText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }.padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
    }
}

struct LatLongView_Previews: PreviewProvider {
    static var previews: some View {
        LatLongView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
