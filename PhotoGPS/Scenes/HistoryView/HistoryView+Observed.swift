//
//  HistoryView+Observed.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 12/5/22.
//

import SwiftUI

extension HistoryView {
    class Observed: ObservableObject {
        @Published var showSettings: Bool = false
        @Published var isSharePresented: Bool = false
    }
}
