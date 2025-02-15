//
//  Utils.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 27/08/24.
//

import Foundation
import AppTrackingTransparency
import CoreLocation
import zlib


internal actor Utils{
    
    internal static func getDeviceSignals<T>(functionName: String, requestId: String, defaultValue: T, function: () async throws -> T) async -> T {
        do {
            return try await function()
        } catch {
            pushSdkError(SdkError(name: functionName, exceptionMsg: error.localizedDescription, requestId: requestId))
            return defaultValue
        }
    }
    
    internal static func getDeviceSignalsWithoutAsync<T>(functionName: String, requestId: String, defaultValue: T, function: () throws -> T) -> T {
        do {
            return try function()
        } catch {
            pushSdkError(SdkError(name: functionName, exceptionMsg: error.localizedDescription, requestId: requestId))
            return defaultValue
        }
    }
    
    internal static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
    
    internal static func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    internal static func dateToString(_ timeStamp: CLong) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST time zone
        return dateFormatter.string(from: date)
    }
    
    internal static func dateToUnixTimestamp(_ date: Date) -> CLong {
        return CLong(date.timeIntervalSince1970)
    }
    
    internal static func hasForegroundLocationPermission() -> Bool{
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    internal static func hasBackgroundLocationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedAlways
    }
    
    internal static func checkLocationServiceEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            return true
        } else {
            return false
        }
    }
    
    internal static func getSessionId() -> String{
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let sessionId = "\(uuid.prefix(8))-\(uuid.prefix(12).suffix(4))-\(uuid.prefix(16).suffix(4))-\(uuid.prefix(20).suffix(4))-\(uuid.suffix(12))"
        return sessionId
    }
    
    internal static func pushEventMetric(_ eventMetric: EventMetric){
        Sign3IntelligenceInternal.sdk?.pushEventMetric(eventMetric)
    }
    
    internal static func pushSdkError(_ sdkError: SdkError){
        Sign3IntelligenceInternal.sdk?.pushSdkError(sdkError)
    }
    
    internal static func createProperties(_ sdkError: SdkError) -> [String: String] {
        var properties: [String: String] = [:]
        
        Task {
            properties["eventName"] = await sdkError.eventName
            properties["name"] = sdkError.name
            properties["exceptionMsg"] = sdkError.exceptionMsg
            properties["requestId"] = sdkError.requestId ?? "unknown"
            properties["createdAtInMillis"] = "\(await sdkError.createdAtInMillis)"
            properties["clientId"] = await sdkError.clientId
            properties["sessionId"] = await sdkError.sessionId
            properties["frameworkVersionName"] = await sdkError.frameworkVersionName
            properties["frameworkVersionCode"] = await sdkError.frameworkVersionCode
        }
        
        return properties
    }
    
    internal static func getRequestID() -> String {
        let uuid = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let sessionId = "\(uuid.prefix(8))-\(uuid.prefix(12).suffix(4))-\(uuid.prefix(16).suffix(4))-\(uuid.prefix(20).suffix(4))-\(uuid.suffix(from: uuid.index(uuid.startIndex, offsetBy: 20)))"
        return sessionId
    }
    
    internal static func getClientParams(
        source: String,
        sign3Intelligence: Sign3IntelligenceInternal
    ) -> ClientParams{
        guard let options = sign3Intelligence.options else {
            Log.e("getClientParams", "Option is nil")
            return ClientParams.empty()
        }
        
        if (sign3Intelligence.updateOptionCheck){
            sign3Intelligence.updateOptionCheck = false
            return ClientParams.fromOptions(options)
        }
        
        switch source.first {
        case "I":
            return ClientParams.fromOptionsInit(options)
        default:
            return ClientParams.fromOptionsCron(options)
        }
    }
    
    /**
     Caution: Please note that while converting complete actor object to json, one extra wrapper of that data needs to be created otherwise JSONEncoder().encode() will throw exception.
     */
    internal static func convertToJson<T: Encodable>(_ object: T) -> String {
        do {
            let jsonData = try JSONEncoder().encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                Log.e("ConvertToJson", "Failed to convert JSON data to string")
                return ""
            }
        } catch {
            Log.e("ConvertToJson", "Failed to convert object to JSON: \(error)")
            return ""
        }
    }
    
    internal static func updateData(
        response: IntelligenceResponse,
        sign3Intelligence: Sign3IntelligenceInternal,
        deviceParams: DeviceParams,
        deviceParamsHash: Int,
        clientParams: ClientParams
    ) {
        let retrievedDeviceFingerprint = KeychainHelper.shared.retrieveDeviceFingerprint()
        if(retrievedDeviceFingerprint == nil) {
            KeychainHelper.shared.saveDeviceFingerprint(deviceFingerprint: response.deviceId)
        }
        sign3Intelligence.currentIntelligence = response
        sign3Intelligence.currentIntelligence?.gpsLocation = deviceParams.iOSdataRequest.gpsLocation
        sign3Intelligence.payloadHash = deviceParamsHash
        sign3Intelligence.deviceParam = deviceParams
        sign3Intelligence.availableMemory = deviceParams.deviceIdRawData.hardwareFingerprintRawData.freeDiskSpace
        sign3Intelligence.sentClientParams = clientParams
        sign3Intelligence.totalMemory = deviceParams.deviceIdRawData.hardwareFingerprintRawData.totalDiskSpace
        sign3Intelligence.locationThresholdReached = false
        sign3Intelligence.memoryThresholdReached = false
    }
    
    internal static func gzip(_ data: Data) throws -> Data {
        guard !data.isEmpty else {
            return Data()
        }

        var stream = z_stream()
        var status: Int32

        // Initialize the zlib stream for Gzip compression with default settings
        status = deflateInit2_(
            &stream,
            Z_DEFAULT_COMPRESSION, // Default compression level
            Z_DEFLATED,
            MAX_WBITS + 16,        // Default window size for Gzip
            MAX_MEM_LEVEL,
            Z_DEFAULT_STRATEGY,
            ZLIB_VERSION,
            Int32(MemoryLayout<z_stream>.size)
        )

        guard status == Z_OK else {
            throw NSError(domain: "GzipError", code: Int(status), userInfo: ["message": String(cString: stream.msg)])
        }

        var compressedData = Data(capacity: 64 * 1024) // Initial buffer size
        var statusDeflate: Int32 = Z_OK
        
        repeat {
            // Expand buffer if needed
            if Int(stream.total_out) >= compressedData.count {
                compressedData.count += 64 * 1024
            }
            var cData = compressedData
            data.withUnsafeBytes { inputPointer in
                guard let baseAddress = inputPointer.bindMemory(to: Bytef.self).baseAddress else {
                    return
                }
                
                stream.next_in = UnsafeMutablePointer<Bytef>(mutating: baseAddress).advanced(by: Int(stream.total_in))
                stream.avail_in = uInt(data.count) - uInt(stream.total_in)

                cData.withUnsafeMutableBytes { outputPointer in
                    guard let outputBaseAddress = outputPointer.bindMemory(to: Bytef.self).baseAddress else {
                        return
                    }
                    
                    stream.next_out = outputBaseAddress.advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(compressedData.count) - uInt(stream.total_out)

                    statusDeflate = deflate(&stream, Z_FINISH)
                }
            }
            
            compressedData = cData

        } while stream.avail_out == 0 && statusDeflate == Z_OK

        guard deflateEnd(&stream) == Z_OK, statusDeflate == Z_STREAM_END else {
            throw NSError(domain: "GzipError", code: Int(statusDeflate), userInfo: ["message": String(cString: stream.msg)])
        }

        compressedData.count = Int(stream.total_out)
        return compressedData
    }
}
