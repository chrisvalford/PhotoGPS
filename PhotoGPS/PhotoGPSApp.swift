//
//  PhotoGPSApp.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 26/5/21.
//

import SwiftUI

@main
struct PhotoGPSApp: App {

    var body: some Scene {
        WindowGroup {
            //CameraView()
            HistoryView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
