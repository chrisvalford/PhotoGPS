//
//  HistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(saves) { item in
                    HistoryViewRow(gpsData: item)
                }
            }
            .navigationBarTitle("History", displayMode: .inline)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
