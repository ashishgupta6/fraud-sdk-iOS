//
//  Utils.swift
//  FraudSDK-iOS
//
//  Created by Ashish Gupta on 29/08/24.
//

import Foundation
import CoreLocation
import AppTrackingTransparency
import zlib


class Utils{
    
    private static let locationManager = CLLocationManager()
    
    static func checkThread(){
        let thread = Thread.current
        let threadId = thread.value(forKeyPath: "private.seqNum") as? Int ?? 0
        print("Thread ID: \(threadId)")
        print("Is Main Thread: \(thread.isMainThread)")
    }
    
    static func requestLocationPermission(){
        // Check the current authorization status
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            // Request permission if not determined yet
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Handle the case where permission is restricted or denied
            print("Location access is restricted or denied.")
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission is already granted
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unhandled authorization status")
        }
    }
    
    static func requestPermissionForIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Log: ATTrackingManager request successful")
                case .denied,
                        .notDetermined,
                        .restricted:
                    print("Log: ATTrackingManager request denied")
                    break
                @unknown default:
                    print("Log: ATTrackingManager request default")
                    break
                }
            }
        } else {
            print("Log: below iOS 14")
        }
    }
    
    static func showInfologs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func showErrorlogs(tags: String, value: String){
        print("\(tags): \(value)")
    }
    
    static func dateToString(_ timeStamp: CLong) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST time zone
        return dateFormatter.string(from: date)
    }
    
    static func gzip(data: Data) throws -> Data {
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
                stream.next_in = UnsafeMutablePointer<Bytef>(
                    mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!
                ).advanced(by: Int(stream.total_in))
                stream.avail_in = uInt(data.count) - uInt(stream.total_in)

            
                cData.withUnsafeMutableBytes { outputPointer in
                    stream.next_out = outputPointer.bindMemory(to: Bytef.self).baseAddress!
                        .advanced(by: Int(stream.total_out))
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
