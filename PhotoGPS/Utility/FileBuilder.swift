//
//  FileBuilder.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 3/6/21.
//

import Foundation


struct FileBuilder {

    static func output(forType: FileType, selectedGPSData: [GPSData]) -> URL? {

        // Build the document here
        var stringOut = """
            <?xml version=\"1.0\" encoding=\"utf-8\"?>
            <gpx version=\"1.1\" creator=\"PhotoGPS\"
            xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">
            <trk>
            """
        stringOut.append("<name>Sample</name>\n")
        stringOut.append("<trkseg>\n")

        for item in selectedGPSData {
            stringOut.append("<trkpt lat=\"\(item.latitude)\" lon=\"\(item.longitude)\">\n")
            stringOut.append("<ele></ele>\n")
            stringOut.append("<hdg>\(item.trueHeading)</hdg>\n")

            stringOut.append("<time>\(formattedDate(item.saved))</time>\n")
            stringOut.append("</trkpt>\n")
        }
        stringOut.append("</trkseg>\n")
        stringOut.append("</trk>\n")
        stringOut.append("</gpx>\n")

        let fileName = "route"
        var documentDirURL: URL
        do {
            documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            print("Error creating file: \(error.localizedDescription)")
            return nil
        }

        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("gpx")
        print("FilePath: \(fileURL.path)")

        do {
            // Write to the file
            try stringOut.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }

        return documentDirURL
    }

    static func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
}
