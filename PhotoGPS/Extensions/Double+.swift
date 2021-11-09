//
//  Double+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import UIKit

extension Double {
    func formatLongitude() -> String {
        let lat = self.decimalDegrees()
        var direction = "W"
        if (lat.0 >= 0 && lat.1 >= 0 && lat.2 > 0) && lat.0 < 180 {
            direction = "E"
        }
        return "\(lat.0)º \(lat.1)' \(lat.2)\" \(direction)"
    }

    func formatLatitude() -> String {
        let lng = self.decimalDegrees()
        var direction = "S"
        if (lng.0 >= 0 && lng.1 >= 0 && lng.2 > 0) && lng.0 < 90 {
            direction = "N"
        }
        return "\(lng.0)º \(lng.1)' \(lng.2)\" \(direction)"
    }

    func formatHeading() -> String {
        return String(format: "%.1f", (self * 10).rounded() / 10)
    }

    func decimalDegrees() -> (Int, Int, Double) {
        let d = Int(self)
        let m = Int((self - Double(d)) * 60)
        let s = (self - Double(d) - Double(m) / 60) * 3600
        let rs = (s * 10).rounded() / 10.0
        return (d, m, rs)
    }
}
