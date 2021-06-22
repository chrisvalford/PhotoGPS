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
    @Environment(\.managedObjectContext) private var viewContext
    @State private var captureCount = UserDefaults.standard.integer(forKey: "Captured")
    
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
                            self.captureCount += 1
                            print("Saved \(self.captureCount) positions")
                            captureCount += 1
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
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 200, alignment: .leading)
                            Text(headingService.headingText)
                                .foregroundColor(.white)
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
                    .background(Color.black.opacity(0.50))
                    Spacer()
                    HStack {


                    }.padding()
                    HStack {
                        VStack {
                            Text("Latitude")
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 100, alignment: .trailing)
                            Text("Longitude")
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.bold)
                                .frame(maxWidth: 100, alignment: .trailing)
                        }
                        VStack {
                            Text(headingService.latitudeText)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(headingService.longitudeText)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Button(action:{
                            customCameraRepresentable.takePhoto()
                        }, label: {
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(14)
                                .background(Color("ArrowColor"))
                                .clipShape(Circle())
                        })
                    }.padding()
                    .background(Color.black.opacity(0.5))
                }
                .navigationBarTitle(Text("Photo GPS"), displayMode: .inline)
                .navigationBarColor(backgroundColor: .black, titleColor: .white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
