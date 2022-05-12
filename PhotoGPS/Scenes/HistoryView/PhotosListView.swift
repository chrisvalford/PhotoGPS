//
//  PhotosListView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 12/5/22.
//

import SwiftUI

struct PhotosListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: GPSData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    @Binding var selectedGPSData: [GPSData]
    @Binding var selectedCount: Int
    
    var body: some View {
        List {
            ForEach(saves, id: \.identifier) { item in
                NavigationLink(destination: HistoryDetailView(item: item)) {
                    HistoryViewRow(gpsData: item, isSelected: selectedGPSData.contains(item)) { }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.selectedGPSData.contains(item) {
                            self.selectedGPSData.removeAll(where: { $0 == item })
                            self.selectedCount -= 1
                        } else {
                            self.selectedGPSData.append(item)
                            self.selectedCount += 1
                        }
                    }
                }
            }.onDelete(perform: self.deleteRows)
        }
    }
    
    private func deleteRows(at indexSet: IndexSet) {
        for index in indexSet {
            let item = saves[index]
            viewContext.delete(item)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
