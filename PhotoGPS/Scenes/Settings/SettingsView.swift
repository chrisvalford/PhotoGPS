//
//  SettingsView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("ShowOnboarding") var showOnboarding: Bool = false
    @Environment(\.presentationMode)
    
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("general.onboarding")) {
                    Toggle(isOn: $showOnboarding) {
                        Text("general.show.again")
                    }
                }
            }
            .navigationTitle("general.settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "x.circle")
                    .accentColor(.orange)
            })
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
            .environment(\.locale, .init(identifier: "es"))
    }
}
