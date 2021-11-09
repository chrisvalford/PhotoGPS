//
//  HeadingView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import SwiftUI

struct HeadingView: View {

    @ObservedObject private var headingService = HeadingService.shared
    
    var body: some View {
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
        .background(Color.white.opacity(0.5))
        .cornerRadius(10)
    }
}

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        HeadingView()
    }
}
