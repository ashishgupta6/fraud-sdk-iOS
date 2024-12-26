//
//  IntelligenceResponse 2.swift
//  Sign3Intelligence
//
//  Created by Sreyans Bohara on 18/12/24.
//


public struct IntelligenceResponse: Codable {
    public let deviceId: String
    public let requestId: String
    public let simulator: Bool
    public let jailbroken: Bool
    public let vpn: Bool
    public let geoSpoofed: Bool
    public let appTampering: Bool
    public let hooking: Bool
    public let proxy: Bool
    public let mirroredScreen: Bool
    public var gpsLocation: GPSLocation?

    enum CodingKeys: String, CodingKey {
        case deviceId = "deviceId"
        case requestId = "requestId"
        case simulator = "simulator"
        case jailbroken = "jailbroken"
        case vpn = "vpn"
        case geoSpoofed = "geoSpoofed"
        case appTampering = "appTampering"
        case hooking = "hooking"
        case proxy = "proxy"
        case mirroredScreen = "mirroredScreen"
        case gpsLocation = "gpsLocation"
        
    }
}