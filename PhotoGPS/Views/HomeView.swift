//
//  HomeView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 4/6/21.
//

import SwiftUI

struct HomeView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
    }
    
    var body: some View {
        TabView(selection: $selection) {
            MasterView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Image(systemName: "camera")
                    Text("Live")
                }

                .tag(0)
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
                .tag(1)
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .blue
        }
        .accentColor(.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
