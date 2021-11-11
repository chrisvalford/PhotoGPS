//
//  HistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import CoreData
import MapKit

struct HistoryView: View {
    
    @State private var selectedGPSData = [GPSData]()
    @State private var showSettings = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    @State private var captureCount = UserDefaults.standard.integer(forKey: "Captured")
    @State private var selectedCount = 0
    
    var body: some View {
        NavigationView {
            List{
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
            }.navigationTitle("PhotoGPS")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {},
                               label: {
                            NavigationLink(destination: CameraView()) {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundColor(.orange)
                            }
                        }
                        )
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showSettings = true
                        }, label: {
                                Image(systemName: "gearshape.circle")
                                    .foregroundColor(.orange)
                        }
                        )
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Menu(content: {
//                            Button(action: {
//                                buildFile(forFileType: .waypoints)
//                            }, label: {
//                                Label("Share as Waypoints", systemImage: "chart.bar.doc.horizontal")
//                            })

//                            Button(action: {
//                                buildFile(forFileType: .route)
//                            }, label: {
//                                Label("Share as a Route", systemImage: "chart.bar.doc.horizontal")
//                            })

//                            Button(action: {
//                                buildFile(forFileType: .track)
//                            }, label: {
//                                Label("Share as a Track", systemImage: "chart.bar.doc.horizontal")
//                            })

                            Button(action: {
                                buildFile(forFileType: .text)
                            }, label: {
                                Label("Share as text", systemImage: "doc.plaintext")
                            })

                            Button(action: {
                                buildFile(forFileType: .csv)
                            }, label: {
                                Label("Share as a CSV", systemImage: "doc.text")
                            })

//                            Button(action: {
//                                buildFile(forFileType: .document)
//                            }, label: {
//                                Label("Share as a document", systemImage: "doc.richtext")
//                            })

                            Button(action: {
                                openInMaps()
                            }, label: {
                                Label("Show in Maps", systemImage: "map")
                            })

                        }) {
                            Image(systemName: "square.and.arrow.up.circle")
                        }
                        .disabled(selectedCount == 0)
                    }
                }.accentColor(.orange)
        }
        .onAppear() {
            // Reset the badge count
            captureCount = 0
        }
        .sheet(isPresented: $showSettings, content: {
            SettingsView()
        })
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
            if let documentURL = FileBuilder.output(forType: .route, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .track:
            print("Building track GPX file")
            if let documentURL = FileBuilder.output(forType: .track, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .text:
            print("Building plain text file")
            if let documentURL = FileBuilder.output(forType: .text, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .csv:
            print("Building CSV file")
            if let documentURL = FileBuilder.output(forType: .csv, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        case .document:
            print("Building Rich Text file")
            if let documentURL = FileBuilder.output(forType: .document, selectedGPSData: selectedGPSData) {
                actionSheet(sharing: documentURL)
            }
        }
    }

    func openInMaps() {
        //TODO:
        let item = selectedGPSData.first

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(item!.latitude, item!.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = item!.saved.debugDescription
        mapItem.openInMaps(launchOptions: options)
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
