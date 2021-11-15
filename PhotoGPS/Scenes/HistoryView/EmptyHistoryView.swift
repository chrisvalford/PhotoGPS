//
//  EmptyHistoryView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 11/11/21.
//

import SwiftUI

struct EmptyHistoryView: View {
    
    var body: some View {
        List {
            Text("nophotos")
                .font(.title)
            HStack {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)

                Text("nophoto.tap1")
            }
            HStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("nophoto.tap2")
            }
            HStack {
                Image(systemName: "square.and.arrow.up.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("nophoto.tap3")
            }
            HStack {
                Image(systemName: "gearshape.circle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(.orange)
                Text("nophoto.tap4")
                    
            }
        }
    }
}

struct EmptyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyHistoryView()
            .environment(\.locale, .init(identifier: "it"))
    }
}
