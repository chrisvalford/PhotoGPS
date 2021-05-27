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
            List{
                ForEach(saves, id: \.identifier) { item in
                    HistoryViewRow(gpsData: item)
                }.onDelete(perform: self.deleteRows)
            }
        }
        .navigationBarTitle("History", displayMode: .inline)
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
