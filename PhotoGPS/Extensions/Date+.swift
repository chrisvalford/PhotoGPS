//
//  Date+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import Foundation

extension Date {
    func localizedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        return formatter.string(from: self)
    }
}
