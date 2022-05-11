//
//  ShareSheet.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 13/11/21.
//

import SwiftUI

struct ShareSheet: View {

    private var selectedGPSData = [GPSData]()
    private var url: URL

    init(selectedGPSData: [GPSData]) {
        self.selectedGPSData = selectedGPSData
        self.url = FileBuilder.output(forType: .text, selectedGPSData: selectedGPSData)!
    }

    var body: some View {
        ActivityViewController(activityItems: [url])
    }

    func buildFile(forFileType: FileType) -> URL {
        switch forFileType {
//        case .waypoints:
//            print("Building waypoint GPX file")
//            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
//                //actionSheet(sharing: documentURL)
//                self.documentURL = documentURL
//                isSharePresented = true
//            }
//        case .route:
//            print("Building route GPX file")
//            if let documentURL = FileBuilder.output(forType: .route, selectedGPSData: selectedGPSData) {
//                //actionSheet(sharing: documentURL)
//                self.documentURL = documentURL
//                isSharePresented = true
//            }
//        case .track:
//            print("Building track GPX file")
//            if let documentURL = FileBuilder.output(forType: .track, selectedGPSData: selectedGPSData) {
//                //actionSheet(sharing: documentURL)
//                self.documentURL = documentURL
//                isSharePresented = true
//            }
        case .text:
            print("Building plain text file")
            if let url = FileBuilder.output(forType: .text, selectedGPSData: selectedGPSData) {
                //actionSheet(sharing: documentURL)
//                isSharePresented = true
                return url
            }
        case .csv:
            print("Building CSV file")
            if let url = FileBuilder.output(forType: .csv, selectedGPSData: selectedGPSData) {
                //actionSheet(sharing: documentURL)
                //self.documentURL = documentURL
//                isSharePresented = true
                return url
            }
//        case .document:
//            print("Building Rich Text file")
//            if let documentURL = FileBuilder.output(forType: .document, selectedGPSData: selectedGPSData) {
//                //actionSheet(sharing: documentURL)
//                self.documentURL = documentURL
//                isSharePresented = true
//            }
        default:
            return URL(string: "apple.com")!
        }
        return URL(string: "apple.com")!
    }


}

//struct ShareSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareSheet()
//    }
//}
