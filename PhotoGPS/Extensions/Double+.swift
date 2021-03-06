//
//  Double+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import UIKit

extension Double {
    func formatLongitude() -> String {
        let lng = self.decimalDegrees()
        var direction = "W"
        if (lng.0 >= 0 && lng.1 >= 0 && lng.2 > 0) && lng.0 < 180 {
            direction = "E"
        }
        return "\(lng.0 < 0 ? lng.0 * -1 : lng.0)º \(lng.1 < 0 ? lng.1 * -1 : lng.1)' \(lng.2 < 0 ? lng.2 * -1 : lng.2)\" \(direction)"
    }

    func formatLatitude() -> String {
        let lat = self.decimalDegrees()
        var direction = "S"
        if (lat.0 >= 0 && lat.1 >= 0 && lat.2 > 0) && lat.0 < 90 {
            direction = "N"
        }
        return "\(lat.0 < 0 ? lat.0 * -1 : lat.0)º \(lat.1 < 0 ? lat.1 * -1 : lat.1)' \(lat.2 < 0 ? lat.2 * -1 : lat.2)\" \(direction)"
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


    var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
    var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }


    /// Convert `Double` to `Decimal`, rounding it to `scale` decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places to round to. Defaults to `0`.
    ///   - mode:  The preferred rounding mode. Defaults to `.plain`.
    /// - Returns: The rounded `String` value.
    
    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> String {
        var decimalValue = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, scale, mode)
        return result.description
    }
    
    // .roundedDecimal(to: 1)
}
