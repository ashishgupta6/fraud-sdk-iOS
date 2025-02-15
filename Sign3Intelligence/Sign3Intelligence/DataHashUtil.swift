//
//  DataHashUtil.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/12/24.
//

import Foundation
import CoreLocation

internal class DataHashUtil {
    
    static func generateHash(_ deviceParams: DeviceParams, _ sign3Intelligence: Sign3IntelligenceInternal) -> Int {
        var latValue: String? = nil
        var longValue: String?
        let hasList = ConfigManager.hasList
        var hashCodeList: [String] = []
        
        let hashData = getHashData(deviceParams: deviceParams)
        
        for data in hasList {
            if let field = getFieldBySerializedName(hashData: hashData, serializedName: data) {
                if let value = field as? String {
                    switch data {
                    case "latitude":
                        latValue = value.description
                    case "longitude":
                        longValue = value.description
                        if let lat = latValue, let long = longValue {
                            sign3Intelligence.locationThresholdReached = checkLocationThreshold(latValue: Double(lat) ?? 0.0, longValue: Double(long) ?? 0.0, sign3Intelligence: sign3Intelligence)
                        }
                    case "availableMemory":
                        if let memory = Int(value) {
                            sign3Intelligence.memoryThresholdReached = checkAvailableMemoryThreshold(calculatedMemory: memory, sign3Intelligence: sign3Intelligence)
                        }
                    default:
                        hashCodeList.append(value)
                    }
                }
            }
        }
        
        let hashCode = hashCodeList.joined().hashValue
        return abs(hashCode)
    }
    
    
    private static func checkAvailableMemoryThreshold(calculatedMemory: Int, sign3Intelligence: Sign3IntelligenceInternal) -> Bool {
        if let availableMemory = sign3Intelligence.availableMemory, let totalMemory = sign3Intelligence.totalMemory {
            let calculatedPercentage = Double(calculatedMemory) / Double(totalMemory) * 100
            let oldPercentage = Double(availableMemory) / Double(totalMemory) * 100
            let percentageDiff = abs(calculatedPercentage - oldPercentage)
            if percentageDiff > Double(ConfigManager.memoryThreshold) {
                return true
            }
        }
        return false
    }
    
    private static func checkLocationThreshold(latValue: Double, longValue: Double, sign3Intelligence: Sign3IntelligenceInternal) -> Bool {
        if let currentIntelligence = sign3Intelligence.currentIntelligence, let startLatitude = currentIntelligence.gpsLocation?.latitude, let startLongitude = currentIntelligence.gpsLocation?.longitude {
            let startPoint = CLLocation(latitude: startLatitude, longitude: startLongitude)
            let endPoint = CLLocation(latitude: latValue, longitude: longValue)
            let distance = startPoint.distance(from: endPoint)
            return distance > Double(ConfigManager.latLongThreshold)
        }
        return false
    }
    
    static func generateHash(_ clientParams: ClientParams?) -> Int {
        guard let clientParams = clientParams else {
            return 0 // Return default if clientParams is nil
        }
        
        do {
            let jsonData = try JSONEncoder().encode(clientParams)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString.hashValue
            }
        } catch {
            Log.e("Error encoding ClientParams to JSON:","\(error.localizedDescription)")
        }
        
        return 0 // Return default in case of an error
    }
    
    private static func getHashData(deviceParams: DeviceParams) -> HashData {
        return HashData(
            isJailbroken: deviceParams.iOSdataRequest.jailBroken,
            isHooking: deviceParams.iOSdataRequest.hooking,
            isVpn: deviceParams.iOSdataRequest.isVpn,
            isProxy: deviceParams.iOSdataRequest.proxy,
            isGeoSpoofed: deviceParams.iOSdataRequest.isGeoSpoofed,
            isSimulator: deviceParams.iOSdataRequest.simulator,
            isMirroredScreen: deviceParams.iOSdataRequest.mirroredScreen,
            isAppTampering: deviceParams.iOSdataRequest.isAppTampering,
            totalMemory: deviceParams.deviceIdRawData.hardwareFingerprintRawData.totalDiskSpace,
            availableMemory: deviceParams.deviceIdRawData.hardwareFingerprintRawData.freeDiskSpace,
            latitude: deviceParams.networkData.networkLocation.latitude,
            longitude: deviceParams.networkData.networkLocation.longitude
        )
    }
    
    private static func getFieldBySerializedName(hashData: HashData, serializedName: String) -> String? {
        var result: String?
        
        Task {
            switch serializedName {
            case "isJailbroken":
                result = "\(await hashData.isJailbroken ?? false)"
            case "isHooking":
                result = "\(await hashData.isHooking ?? false)"
            case "isVpn":
                result = "\(await hashData.isVpn ?? false)"
            case "isProxy":
                result = "\(await hashData.isProxy ?? false)"
            case "isGeoSpoofed":
                result = "\(await hashData.isGeoSpoofed ?? false)"
            case "isSimulator":
                result = "\(await hashData.isSimulator ?? false)"
            case "isMirroredScreen":
                result = "\(await hashData.isMirroredScreen ?? false)"
            case "isAppTampering":
                result = "\(await hashData.isAppTampering ?? false)"
            case "availableMemory":
                result = "\(await hashData.availableMemory)"
            case "latitude":
                if let latitude = await hashData.latitude {
                    result = "\(latitude)"
                }
            case "longitude":
                if let longitude = await hashData.longitude {
                    result = "\(longitude)"
                }
            default:
                break
            }
        }
        
        return result
    }

    
}
