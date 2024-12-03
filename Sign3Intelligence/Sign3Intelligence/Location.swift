//
//  Location.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 04/09/24.
//

import Foundation

internal class Location {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var timeStamp: CLong

    init(latitude: Double, longitude: Double, altitude: Double, timeStamp: CLong) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timeStamp = timeStamp
    }
}
