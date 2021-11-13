//
//  ActivityViewController.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 12/11/21.
//

import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
        var applicationActivities: [UIActivity]? = nil
        let excludedActivityTypes: [UIActivity.ActivityType]? = nil
        @Environment(\.presentationMode) var presentationMode

        func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
            controller.excludedActivityTypes = excludedActivityTypes
            controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                self.presentationMode.wrappedValue.dismiss()
            }
            return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController,
                                    context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
