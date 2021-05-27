//
//  ContentView.swift
//  SwiftUIScanner
//
//  Created by Tim Owings on 11/3/19.
//  Copyright © 2019 Tim Owings. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    
    @ObservedObject private var headingService: HeadingService
    @State private var imageCount = 0
    @Environment(\.managedObjectContext) private var viewContext
    
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: { _ in }
    )
    
    init() {
        headingService = HeadingService.shared
    }
    
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
                    HStack {
                        VStack {
                            Text("Heading")
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 200, alignment: .leading)
                            Text(headingService.headingText)
                                .frame(maxWidth: 200, alignment: .leading)
                        }
                        Spacer()
                        Image("CompasArrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0)
                            .rotationEffect(.degrees( headingService.rotation))
                    }.padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(10)
                    Spacer()
                    HStack {


                    }.padding()
                    HStack {
                        VStack {
                            Text("Latitude")
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 100, alignment: .trailing)
                            Text("Longitude")
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 100, alignment: .trailing)
                        }
                        VStack {
                            Text(headingService.latitudeText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(headingService.longitudeText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                    .allowsHitTesting(false) // Pass the tap to the lower view
                }
                .navigationBarTitle(Text("Photo GPS"), displayMode: .inline)
                .navigationBarItems(trailing:
                                        NavigationLink(destination: HistoryView()
                                                        .environment(\.managedObjectContext, self.viewContext)) {
                                            Image(systemName: "clock").imageScale(.large)
                                        }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
