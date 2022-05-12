//
//  HistoryContentView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 12/5/22.
//

import SwiftUI

struct HistoryContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GPSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    @Binding var selectedGPSData: [GPSData]
    @Binding var selectedCount: Int
    
    @ViewBuilder
    var body: some View {
        if saves.count > 0 {
            PhotosListView(selectedGPSData: $selectedGPSData,
                           selectedCount: $selectedCount)
        } else {
            EmptyHistoryView()
        }
    }
}
