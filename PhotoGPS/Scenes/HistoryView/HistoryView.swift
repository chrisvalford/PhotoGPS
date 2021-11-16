//
//  HistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import CoreData
import MapKit

class HistoryContentViewModel: ObservableObject {
    @Published var showSettings: Bool = false
    @Published var isSharePresented: Bool = false
}

struct HistoryView: View {
    @State private var selectedGPSData = [GPSData]()
    @StateObject private var model = HistoryContentViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GPSData.saved, ascending: false)],
        animation: .default)
    
    private var saves: FetchedResults<GPSData>
    @State private var captureCount = UserDefaults.standard.integer(forKey: "Captured")
    @State private var documentURL: URL?
    @State private var selectedCount = 0
    @State private var imageCount = 0
    @State var photoTaken = false
    
    var body: some View {
        NavigationView {
            listView
                .navigationTitle("PhotoGPS")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {},
                               label: {
                            NavigationLink(destination: CameraView(imageCount: $imageCount)) {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundColor(.orange)
                            }
                        }
                        )
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            model.showSettings = true
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
                                model.isSharePresented = true
                            }, label: {
                                Label("menu.share.text", systemImage: "doc.plaintext")
                            })

                            Button(action: {
                                model.isSharePresented = true
                            }, label: {
                                Label("menu.share.csv", systemImage: "doc.text")
                            })

                            Button(action: {
                                openInMaps()
                            }, label: {
                                Label("menu.show.in.maps", systemImage: "map")
                            })

                        }) {
                            Image(systemName: "square.and.arrow.up.circle")
                        }
                        .disabled(selectedCount == 0)
                    }
                }.accentColor(.orange)
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            // Reset the badge count
            captureCount = 0
            imageCount = saves.count
        }
        .sheet(isPresented: $model.showSettings, content: {
            SettingsView()
        })
        .sheet(isPresented: $model.isSharePresented, content: {
            ShareSheet(selectedGPSData: self.selectedGPSData)
        })
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

    @ViewBuilder
    var listView: some View {
        if imageCount > 0 {
            objectsListView
        } else {
            EmptyHistoryView()
        }
    }

    var objectsListView: some View {
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
            imageCount -= 1
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
