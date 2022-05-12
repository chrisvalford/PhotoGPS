//
//  PhotoPicker.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 11/5/22.
//

import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    // let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    let configuration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        // Specify type of media to be filtered or picked. Default is all
        configuration.filter = .any(of: [.images,.livePhotos,.videos])
        // For unlimited selections use 0. Default is 1
        configuration.selectionLimit = 10
        return configuration
    }()
    
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false // Set isPresented to false because picking has finished.
            for result in results {
                result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier,
                                                              completionHandler: { data, error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    }
                    if let data = data {
                        let src = CGImageSourceCreateWithData(data as CFData, nil)!
                        let metadata = CGImageSourceCopyPropertiesAtIndex(src,0,nil) as! [AnyHashable:Any]
                        let gpsMetadata = metadata["{GPS}"] as? [AnyHashable:Any]
                        if gpsMetadata == nil {
                            print("No GPS data for \(result.itemProvider.suggestedName ?? "")")
                            return
                        }
                        let exifData = metadata["{Exif}"] as? [AnyHashable:Any]
                        if exifData == nil {
                            print("No EXIF data for \(result.itemProvider.suggestedName ?? "")")
                            return
                        }
                        
                        var date = Date()
                        if let dateTimeOriginal = exifData?["DateTimeOriginal"] as? String {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                            date = formatter.date(from: dateTimeOriginal) ?? Date()
                            print(dateTimeOriginal)
                            print(date.description)
                        }
                        print(gpsMetadata ?? "No GPS Data")
                        
                        let context = PersistenceController.shared.container.newBackgroundContext()
                        let gpsData = GPSData(context: context)
                        gpsData.identifier = UUID()
                        guard let latitude = gpsMetadata?["Latitude"] as? Double,
                              let longitude = gpsMetadata?["Longitude"] as? Double,
                              let latitudeRef = gpsMetadata?["LatitudeRef"] as? String,
                              let longitudeRef = gpsMetadata?["LongitudeRef"] as? String,
                              let trueHeading = gpsMetadata?["ImgDirection"] as? Double,
                              let elevation = gpsMetadata?["Altitude"] as? Double else {
                            return
                        }
                        gpsData.latitude = latitudeRef == "N" ? latitude : latitude * -1
                        gpsData.longitude = longitudeRef == "E" ? longitude : longitude * -1
                        gpsData.trueHeading = trueHeading
                        gpsData.elevation = elevation
                        // gpsData.accuracy = gpsMetadata?["accuracy"]
                        gpsData.image = data
                        gpsData.saved = date
                        print(gpsData)
                        do {
                            try context.save()
                        } catch {
                            let nsError = error as NSError
                            print("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                })
                print()
            }
        }
    }
}
