//
//  HomeView.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 4/6/21.
//

import SwiftUI

struct HomeView: View {

    @Environment(\.managedObjectContext) private var viewContext
    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 2
    @State private var selection = 0
    @State private var captureCount = UserDefaults.standard.integer(forKey: "Captured")
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
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
                
                if captureCount > 0 {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        
                        Text("\(captureCount)")
                            .foregroundColor(.white)
                            .font(Font.system(size: 12))
                    }
                    .frame(width: 15, height: 15)
                    .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -30)
                    .opacity(1.0)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
