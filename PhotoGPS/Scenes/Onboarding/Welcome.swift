//
//  Welcome1.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import SwiftUI

struct Welcome: View {

    @Binding var showOnboarding: Bool
    @State private var privacyPermissions = PrivacyPermissions.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image("Sample01")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .cornerRadius(20)
                        VStack {
                            Text("Record your journey with photographs, and then export their location data to you favorite GPS system.")
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .padding(.vertical)
                            if privacyPermissions.cameraPrivacy == PermissionState.notDetermined {
                                Button(action: {
                                    PrivacyPermissions.shared.askCameraPermission()
                                }, label: {
                                    Label("Allow camera", systemImage: "camera")

                                })
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(.infinity)
                            }
                        }
                    }
                    Divider()
                    HStack {
                        VStack {
                            Text("Your heading is included so you can photograph a landmark and then plot it on a marine chart or map.")
                                .multilineTextAlignment(.trailing)
                                .font(.body)
                                .padding(.vertical)
                            if privacyPermissions.locationPrivacy == PermissionState.notDetermined {
                                Button(action: {
                                    PrivacyPermissions.shared.askLocationPermission()
                                }, label: {
                                    Label("Allow location", systemImage: "mappin.circle")

                                })
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(.infinity)
                            }
                        }

                        Image("Sample02")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .cornerRadius(20)
                    }
                    Divider()
                    Text("Ideal as an aid to marine navigation, especially as you take the photo to record your location when you want, and not continuously, so saving your phones battery life.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    Button(action:{
                        @AppStorage("ShowOnboarding") var showOnboarding: Bool = false
                        showOnboarding = false
                    }, label: {
                        Text("Done")
                    })
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(Color.white)
                        .cornerRadius(.infinity)
                    Text("You can change your privacy settings at any time")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .onAppear {
                    PrivacyPermissions.shared.checkCameraPermission()
                }
                .navigationTitle("PhotoGPS")
                .navigationBarTitleDisplayMode(.inline)

            }.padding(.horizontal, 6)
        }
    }

}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(showOnboarding: .constant(true))
    }
}
