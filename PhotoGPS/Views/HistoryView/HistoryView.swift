//
//  HistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    
    @State private var selectedGPSData = [GPSData]()
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    
    var body: some View {
        NavigationView {
            List{
                ForEach(saves, id: \.identifier) { item in
                    HistoryViewRow(gpsData: item, isSelected: selectedGPSData.contains(item)) { }
                    .contentShape(Rectangle())
                                .onTapGesture {
                                    if self.selectedGPSData.contains(item) {
                                        self.selectedGPSData.removeAll(where: { $0 == item })
                                    } else {
                                        self.selectedGPSData.append(item)
                                    }
                                }
                }.onDelete(perform: self.deleteRows)
            }
        }
        .navigationBarTitle("History", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: actionSheet, label: {
            Image(systemName: "square.and.arrow.up.on.square")
        }))
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
    
    func actionSheet() {
        // Build the document here
        
        // Then provide share sheet
            guard let urlShare = URL(string: "https://developer.apple.com/xcode/swiftui/") else { return }
            let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
