//
//  PhotoGPSApp.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 26/5/21.
//

import SwiftUI

@main
struct PhotoGPSApp: App {

    @AppStorage("ShowOnboarding") var showOnboarding: Bool = true

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                Welcome(showOnboarding: $showOnboarding)
            } else {
                HistoryView()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
        }
    }
}
