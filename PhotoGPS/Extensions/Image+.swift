//
//  Image+.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 9/11/21.
//

import SwiftUI

extension Image {
    init(data: Data) {
        if let uiImage = UIImage(data: data) {
            self = Image(uiImage: uiImage)
        } else {
            self = Image(systemName: "xmark.octagon")
        }
    }
}
