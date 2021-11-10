//
//  Welcome1.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import SwiftUI

struct Welcome: View {

    @Binding var showOnboarding: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Welcome to")
                    .font(.title2)
                Spacer()
            }
            HStack {
                Spacer()
                Text("PhotoGPS")
                    .font(.title)
            }
            Text("Record your locations with photographs, then export your journey data to you favorite GPS systems.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Text("We have included your heading so you can photograph a landmark and then plot on a chart or map.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Text("Ideal for marine navigation, especially as you take the photo and record your location when you want, and not continuously, saving your battery.")
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
        }.padding()
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(showOnboarding: .constant(true))
    }
}
