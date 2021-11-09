//
//  ContentView.swift
//  SwiftUIScanner
//
//  Created by Tim Owings on 11/3/19.
//  Copyright © 2019 Tim Owings. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @ObservedObject private var headingService = HeadingService.shared
    @Environment(\.managedObjectContext) private var viewContext
    @State private var imageCount = 0
    
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: { _ in }
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomCameraView(
                    customCameraRepresentable: customCameraRepresentable,
                    imageCompletion: { success in
                        if success == true {
                            self.imageCount += 1
                            print("Saved \(self.imageCount) positions")
                        }
                    }
                )
                .onAppear {
                    customCameraRepresentable.startRunningCaptureSession()
                }
                .onDisappear {
                    customCameraRepresentable.stopRunningCaptureSession()
                }
                
                VStack {
                    HeadingView()
                    Spacer()
                    HStack {


                    }.padding()
                    LatLongView()
                    .allowsHitTesting(false) // Pass the tap to the lower view
                    
                }
                .navigationTitle("PhotoGPS")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {},
                               label: {
                            NavigationLink(destination: HistoryView()
                                            .environment(\.managedObjectContext, viewContext)) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .foregroundColor(.orange)
                            }
                        }
                        )
                    }
                }
            }
        }.accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
