//
//  HistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 27/5/21.
//

import SwiftUI
import CoreData
import MapKit
import PhotosUI

class HistoryContentViewModel: ObservableObject {
    @Published var showSettings: Bool = false
    @Published var isSharePresented: Bool = false
}

struct HistoryView: View {
    @State private var selectedGPSData = [GPSData]()
    @StateObject private var model = HistoryContentViewModel()
    @State private var captureCount = UserDefaults.standard.integer(forKey: "Captured")
    @State private var documentURL: URL?
    @State private var selectedCount = 0
    @State var photoTaken = false
    
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        NavigationView {
            HistoryContentView(selectedGPSData: $selectedGPSData,
                               selectedCount: $selectedCount)
                .navigationTitle("PhotoGPS")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack(spacing: 16) {
                        Button(action: {},
                               label: {
                            NavigationLink(destination: CameraView()) {
                                Image(systemName: "camera.viewfinder")
                                    .foregroundColor(.orange)
                            }
                        }
                        )
                        Button(action: {
                            isPickerPresented.toggle()
                        }, label: {
                            Image(systemName: "photo.circle")
                                .foregroundColor(.orange)
                        }
                        )
                        }
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
        }
        .sheet(isPresented: $model.showSettings, content: {
            SettingsView()
        })
        .sheet(isPresented: $model.isSharePresented, content: {
            ShareSheet(selectedGPSData: self.selectedGPSData)
        })
        .sheet(isPresented: $isPickerPresented, onDismiss: {}) {
            PhotoPicker(isPresented: $isPickerPresented)
        }
    }

    func openInMaps() {
        var items: [MKMapItem] = []
        var coordinates: [CLLocationCoordinate2D] = []
        
        var loopCount = 1
        for item in selectedGPSData {
            let coordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
            coordinates.append(coordinate)
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Photo: \(loopCount)" //item.saved.debugDescription
            items.append(mapItem)
            loopCount += 1
        }
        
        // let regionDistance:CLLocationDistance = 10000
        guard let regionSpan = MKCoordinateRegion(coordinates: coordinates)  else {
            return
        }
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        MKMapItem.openMaps(with: items, launchOptions: options)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
