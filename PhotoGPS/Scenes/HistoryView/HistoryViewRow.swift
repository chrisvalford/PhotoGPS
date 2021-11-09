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
            Image(data: gpsData.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            Text(localizedDate(gpsData.saved))
                .font(.caption)
            if self.isSelected {
                Spacer()
                Image(systemName: "checkmark")
            }
        }
        
    }
    
    func localizedDate(_ date: Date?) -> String {
        guard let date = date else { return "Missing!" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        return formatter.string(from: date)
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
