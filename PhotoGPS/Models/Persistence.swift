//
//  Persistence.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 26/5/21.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let gpsData = GPSData(context: viewContext)
            gpsData.identifier = UUID()
            gpsData.saved = Date()
            gpsData.latitude = 41.372
            gpsData.longitude = 2.1599
            gpsData.trueHeading = 320
            gpsData.magneticHeading = 320.7
            gpsData.elevation = 0
            gpsData.accuracy = 0
//            if let image = sampleImage() {
//                gpsData.image = image.jpegData(compressionQuality: 1.0)
//            }
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PhotoGPS")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static func sampleImage() -> UIImage? {
        var image: UIImage?
        if let imgPath = Bundle.main.path(forResource: "ainvar", ofType: ".jpeg") {
            image = UIImage(contentsOfFile: imgPath)
        }
        return image
    }
}
