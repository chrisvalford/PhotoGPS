//
//  HistoryViewRow.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI

struct HistoryViewRow: View {
    
    var gpsData: GPSData
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            if self.isSelected {
                Image(systemName: "checkmark.circle")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
            } else {
                Image(systemName: "circle")
                    .frame(width: 20, height: 20)
                    .foregroundColor(.orange)
            }
            Image(data: gpsData.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Text(gpsData.saved?.localizedDate() ?? " - ")
                .font(.caption)
        }
    }
}

//struct HistoryViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryViewRow()
//    }
//}

extension Image {
    init(data: Data) {
        if let uiImage = UIImage(data: data) {
            self = Image(uiImage: uiImage)
        } else {
            self = Image(systemName: "xmark.octagon")
        }
    }
}
