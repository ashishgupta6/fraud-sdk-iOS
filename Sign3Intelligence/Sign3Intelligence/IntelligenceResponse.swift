//
//  DeviceSignals.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 29/08/24.
//

public struct IntelligenceResponse: Codable {
    public let deviceId: String
    public let requestId: String
    public let issimulatorDetected: Bool
    public let isJailbroken: Bool
    public let isVpnEnabled: Bool
    public let isGeoSpoofed: Bool
    public let isAppTamperedL: Bool
    public let isHooked: Bool
    public let isProxyDetected: Bool
    public let isMirroredScreenDetected: Bool
    public var gpsLocation: GPSLocation?

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case requestId = "requestId"
        case issimulatorDetected = "issimulatorDetected"
        case isJailbroken = "isJailbroken"
        case isVpnEnabled = "isVpnEnabled"
        case isGeoSpoofed = "isGeoSpoofed"
        case isAppTamperedL = "isAppTamperedL"
        case isHooked = "isHooked"
        case isProxyDetected = "isProxyDetected"
        case isMirroredScreenDetected = "isMirroredScreenDetected"
        case gpsLocation = "gpsLocation"
        
    }
}
