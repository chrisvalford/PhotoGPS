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
                            Text("welcome.text1")
                                .multilineTextAlignment(.leading)
                                .font(.body)
                                .padding(.vertical)
                            if privacyPermissions.cameraPrivacy == PermissionState.notDetermined {
                                Button(action: {
                                    PrivacyPermissions.shared.askCameraPermission()
                                }, label: {
                                    Label("privacy.allow.camera", systemImage: "general.camera")

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
                            Text("welcome.text2")
                                .multilineTextAlignment(.trailing)
                                .font(.body)
                                .padding(.vertical)
                            if privacyPermissions.locationPrivacy == PermissionState.notDetermined {
                                Button(action: {
                                    PrivacyPermissions.shared.askLocationPermission()
                                }, label: {
                                    Label("privacy.allow.location", systemImage: "mappin.circle")

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
                    Text("welcome.text3")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    Button(action:{
                        @AppStorage("ShowOnboarding") var showOnboarding: Bool = false
                        showOnboarding = false
                    }, label: {
                        Text("general.done")
                    })
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(Color.white)
                        .cornerRadius(.infinity)
                    Text("privacy.settings.change")
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
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "es"))
    }
}
