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
//        .navigationBarItems(trailing: Button(action: actionSheet, label: {
//            Image(systemName: "square.and.arrow.up.on.square")
//        }))
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: {
                            buildFile(forFileType: .waypoints)
                    }, label: {
                        Label("Share as Waypoints", systemImage: "chart.bar.doc.horizontal")
                    })

                    Button(action: {
                        buildFile(forFileType: .route)
                    }, label: {
                        Label("Share as a Route", systemImage: "chart.bar.doc.horizontal")
                    })

                    Button(action: {
                        buildFile(forFileType: .track)
                    }, label: {
                        Label("Share as a Track", systemImage: "chart.bar.doc.horizontal")
                    })

                    Button(action: {}, label: {
                        Label("Share as text", systemImage: "doc.plaintext")
                    })

                    Button(action: {}, label: {
                        Label("Share as a CSV", systemImage: "doc.text")
                    })

                    Button(action: {}, label: {
                        Label("Share as a document", systemImage: "doc.richtext")
                    })

                    Button(action: {}, label: {
                        Label("Show in Maps", systemImage: "map")
                    })
                }
                label: {
                    Label("Add", systemImage: "square.and.arrow.up")
                }
//            }
//        }
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

    func buildFile(forFileType: FileType) {

        switch forFileType {
        case .waypoints:
            print("Building waypoint GPX file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .route:
            print("Building route GPX file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .track:
            print("Building track GPX file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .text:
            print("Building plain text file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .csv:
            print("Building CSV file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .document:
            print("Building Rich Text file")
            if let documentURL = FileBuilder.output(forType: .waypoints, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        }
    }
    
    func actionSheet(sharing url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
