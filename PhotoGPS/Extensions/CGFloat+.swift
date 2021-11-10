//
//  CGFloat+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 10/11/21.
//

import UIKit

extension CGFloat {
  var degreesToRadians: CGFloat { return self * .pi / 180 }
  var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
