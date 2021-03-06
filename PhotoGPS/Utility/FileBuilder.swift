//
//  FileBuilder.swift
//  PhotoGPS
//
//  Created by Christopher Alford on 3/6/21.
//

import Foundation

struct FileBuilder {

    static var selectedGPSData = [GPSData]()
    static var outString = ""
    static var fileName = ""
    static var fileExtension = ""

    static func output(forType: FileType, selectedGPSData: [GPSData]) -> URL? {

        self.selectedGPSData = selectedGPSData

        switch forType {
        case .waypoints:
            fileName = "waypoints"
            fileExtension = "gpx"
        case .route:
            fileName = "route"
            fileExtension = "gpx"
            buildRoute()
        case .track:
            fileName = "track"
            fileExtension = "gpx"
            buildTrack()
        case .text:
            fileName = "PhotoGPS"
            fileExtension = "txt"
            buildText()
        case .csv:
            fileName = "PhotoGPS"
            fileExtension = "csv"
            buildCSV()
        case .document:
            fileName = "PhotoGPS"
            fileExtension = "rtf"
            buildRichText()
        }

        var documentDirURL: URL
        do {
            documentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        } catch {
            print("Error creating file: \(error.localizedDescription)")
            return nil
        }

        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        print("FilePath: \(fileURL.path)")

        do {
            // Write to the file
            try outString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }

        return fileURL
    }

    static func buildTrack() {
        outString = """
            <?xml version=\"1.0\" encoding=\"utf-8\"?>
            <gpx version=\"1.1\" creator=\"PhotoGPS\"
            xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">\n
            """
        outString.append("<name>\(fileName)</name>\n")
        outString.append("<trk>\n<trkseg>\n")

        for item in selectedGPSData {
            outString.append("<trkpt lat=\"\(item.latitude)\" lon=\"\(item.longitude)\">\n")
            outString.append("<ele></ele>\n")
            outString.append("<hdg>\(item.trueHeading)</hdg>\n")

            outString.append("<time>\(formattedDate(item.saved))</time>\n")
            outString.append("</trkpt>\n")
        }
        outString.append("</trkseg>\n")
        outString.append("</trk>\n")
        outString.append("</gpx>\n")
    }

    static func buildRoute() {
        outString = """
            <?xml version=\"1.0\" encoding=\"utf-8\"?>
            <gpx version=\"1.1\" creator=\"PhotoGPS\"
            xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">
            <rte>
            """
        outString.append("<name>\(fileName)</name>\n")

        for item in selectedGPSData {
            outString.append("<rtept lat=\"\(item.latitude)\" lon=\"\(item.longitude)\">\n")
            outString.append("<name>\(formattedDate(item.saved))</name>\n")
            outString.append("<sym>BLANK</sym>\n")
            outString.append("</rtept>\n")
        }
        outString.append("</rte>\n")
        outString.append("</gpx>\n")
    }

    static func buildText() {
        outString = ""
        for item in selectedGPSData {
            outString.append("Latitude: \(item.latitude)\n")
            outString.append("Longitude: \(item.longitude)\n")
            outString.append("Heading (T): \(item.trueHeading)\n")
            outString.append("Time: \(formattedDate(item.saved))\n")
            outString.append("Elevation: \(item.elevation)\n")
            outString.append("Accuracy: \(item.accuracy)\n\n")
        }
    }

    static func buildCSV() {
        outString = "Latitude,Longitude,Heading (T),Time,Elevation,Accuracy\n"
        for item in selectedGPSData {
            outString.append("\(item.latitude),")
            outString.append("\(item.longitude),")
            outString.append("\(item.trueHeading),")
            outString.append("\(formattedDate(item.saved)),")
            outString.append("\(item.elevation),")
            outString.append("\(item.accuracy)\n")
        }
    }

    static func buildRichText() {
        outString = "{\\rtf1\\ansi\\ansicpg1252\\cocoartf2580\\cocoatextscaling0\\cocoaplatform0{\\fonttbl\\f0\\fnil\\fcharset0 HelveticaNeue-Bold;\\f1\\fswiss\\fcharset0 Helvetica;\\f2\\fnil\\fcharset0 HelveticaNeue;"
        outString.append("}\n")
        outString.append("{\\colortbl;\\red255\\green255\\blue255;\\red0\\green0\\blue0;\\red176\\green179\\blue178;\\red242\\green242\\blue242;")
        outString.append("}\n")
        outString.append("{\\*\\expandedcolortbl;;\\cssrgb\\c0\\c0\\c0;\\cssrgb\\c74351\\c75369\\c75059;\\cssrgb\\c96078\\c96078\\c96078;")
        outString.append("}\n")
        outString.append("\\paperw15840\\paperh12240\\margl1440\\margr1440\n")
        outString.append("\\deftab720\n")

        outString.append("\\itap1\\trowd \\taflags1 \\trgaph108\\trleft-108 \\trbrdrt\\brdrnil \\trbrdrl\\brdrnil \\trbrdrr\\brdrnil\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth1980\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx1440\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth1980\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx2880\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth1980\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx4320\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth2140\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx5760\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth2060\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx7200\n")
        outString.append("\\clvertalt \\clcbpat3 \\clwWidth1700\\clftsWidth3 \\clheight280 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx8640\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Latitude\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Longitude\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Heading (T)\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Time\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Elevation\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
        outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

        outString.append("\\f0\\b\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone Accuracy\n")
        outString.append("\\f1\\b0\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell \\row\n")

        for item in selectedGPSData {
            outString.append("\\itap1\\trowd \\taflags1 \\trgaph108\\trleft-108 \\trbrdrl\\brdrnil \\trbrdrr\\brdrnil\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth1980\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx1440\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth1980\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx2880\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth1980\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx4320\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth2140\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx5760\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth2060\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx7200\n")
            outString.append("\\clvertalt \\clshdrawnil \\clwWidth1700\\clftsWidth3 \\clheight260 \\clbrdrt\\brdrs\\brdrw20\\brdrcf2 \\clbrdrl\\brdrs\\brdrw20\\brdrcf2 \\clbrdrb\\brdrs\\brdrw20\\brdrcf2 \\clbrdrr\\brdrs\\brdrw20\\brdrcf2 \\clpadt80 \\clpadl80 \\clpadb80 \\clpadr80 \\gaph\\cellx8640\n")
            
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n\n")
            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(item.latitude)\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n\n")

            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(item.longitude)\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n")

            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(item.trueHeading)\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n\n")

            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(formattedDate(item.saved))\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n\n")

            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(item.elevation)\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell\n")
            outString.append("\\pard\\intbl\\itap1\\pardeftab720\\partightenfactor0\n\n")

            outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone \(item.accuracy)\n")
            outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone \\cell \\row\n\n")
        }

        outString.append("\\f2\\fs20 \\cf2 \\up0 \\nosupersub \\ulnone 0.0\n")
        outString.append("\\f1\\fs24 \\cf0 \\up0 \\nosupersub \\ulnone\n")
        outString.append("\\cell \\lastrow\\row\n")

    }

    static func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
}

/*
 Waypoint is a waypoint (???wpt??? entity in the GPX file).

 Route point (???rtept??? entity in the GPX file) may, but does not have to, also be a waypoint.

 All the navobjects with the exception of track points (???trkpt??? entity in the GPX file) do have
 a ???GUID??? in GPX produced by OpenCPN.

 The ???GUID??? is the primary identifier used to see if the object already exists or not (with the
 exception of ???wpt??? import, see below).

 Two objects with the same ???GUID??? can not exist at the same time.

 A waypoint may also be included in zero to many routes.

 A route point may not exist without a route though (= must be included in 1 to many existing
 routes and unlike a waypoint, it is also for example deleted with the last route it is a part of).

 It is not possible to have the same waypoint in a layer and then import it from a GPX file.

 The logic used for ???wpt??? entities during the import to determine duplicates is the ???Name??? and ???lat??? + ???lon???,
 (because we can not rely on the imported entity having the OpenCPN specific GUID extension during the import).

 The ???GUID??? represents the internal globally unique identifier of the navobject in OpenCPN and is completely
 irrelevant in the waypoint import from GPX as you can see above (It is used elsewhere for other purposes).

 Import of a Route Gpx File with duplicate waypoints will result in a message, and the existing waypoint will be shared.
 
 <gpx>
 // Your intended route
     <rte>
         <rtept lat="13.09993" lon="77.58959">
             <name>Start</name>
             <cmt>Start of route</cmt>
         </rtept>
         <rtept lat="13.10052" lon="77.58847">
             <name>Left</name>
             <cmt>Turn left onto SH 9</cmt>
         </rtept>
     </rte>

 // Your actual track through the water
     <trk>
         <trkseg>
             <trkpt lat="13.09993" lon="77.58959">
                 <ele>923.2</ele>
             </trkpt>
             <trkpt lat="13.10031" lon="77.58915">
                 <ele>924.0</ele>
             </trkpt>
             <trkpt lat="13.1006699" lon="77.58872">
                 <ele>924.1</ele>
             </trkpt>
         </trkseg>
     </trk>
 </gpx>
*/
