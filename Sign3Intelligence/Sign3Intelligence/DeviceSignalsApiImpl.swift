//
//  DeviceSignalsApiImpl.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 20/08/24.
//

import Foundation
import UIKit
import AdSupport
import CoreTelephony
import CloudKit
import AppTrackingTransparency
import AVFoundation
import LocalAuthentication
import CoreMotion
import DeviceCheck
import Network
import SystemConfiguration.CaptiveNetwork

internal class DeviceSignalsApiImpl : DeviceSignalsApi{
    
    init() {}
    
    func generateDeviceToken() async -> String {
        await Utils.getDeviceSignals(
            functionName: "generateDeviceToken",
            requestId: UUID().uuidString,
            defaultValue: "Unknown"
        ) {
            let currentDevice = DCDevice.current
            if currentDevice.isSupported {
                return await withCheckedContinuation { continuation in
                    currentDevice.generateToken { data, error in
                        if let tokenData = data {
                            continuation.resume(returning: tokenData.base64EncodedString())
                        } else {
                            continuation.resume(returning: "")
                        }
                    }
                }
            } else {
                return "Unsupported Device"
            }
        }
    }

    
    func getiOSDeviceId() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getiOSDeviceId",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                guard let id = await UIDevice.current.identifierForVendor?.uuidString else {
                    return "Unable to get device ID"
                }
                return id
            }
        )
    }
    
    func getIDFA() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getIDFA",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if isTrackingAccessAvailable() {
                    if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    } else {
                        return "Unknown"
                    }
                }
                return "IDFA is not available"
            }
        )
    }
    
    func isTrackingAccessAvailable() -> Bool {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                return true
            case .notDetermined, .restricted, .denied:
                return false
            @unknown default:
                return false
            }
        } else {
            return true // As there is no tracking authorization in earlier versions
        }
    }
    
    func getCloudId() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCloudId",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let container = CKContainer.default()
                do {
                    let recordID = try await container.userRecordID()
                    return recordID.recordName
                }catch {
                    return error.localizedDescription
                }
            }
        )
    }
    
    func getApplicationId() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getApplicationId",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Bundle.main.bundleIdentifier ?? "Unknown"
            }
        )
    }
    
    func getBatteryStatus() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getBatteryStatus",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await fetchBatteryStatus()
            }
        )
    }
    
    private func fetchBatteryStatus() async -> String {
        let device = await UIDevice.current
        await MainActor.run {
            // Perform the device.isBatteryMonitoringEnabled change on the main actor
            device.isBatteryMonitoringEnabled = true
        }
        switch await device.batteryState {
        case .unknown:
            return "Battery state is unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown battery state"
        }
    }
    
    func getBatteryLevel() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getBatteryLevel",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                await fetchBatteryLevel()
            }
        )
    }
    
    func fetchBatteryLevel() async -> Float {
        let device = await UIDevice.current
        
        await MainActor.run {
            // Perform the device.isBatteryMonitoringEnabled change on the main actor
            device.isBatteryMonitoringEnabled = true
        }
        return await device.batteryLevel
        
    }
    
    func getCpuCount() async -> Int {
        return await Utils.getDeviceSignals(
            functionName: "getCpuCount",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                return ProcessInfo.processInfo.processorCount
            }
        )
    }
    
    
    func getFreeDiskSpace() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getFreeDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: -1,
            function: {
                if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
                   let freeSpace = attributes[.systemFreeSize] as? Int64 {
                    return CLong(freeSpace)
                    //                    return ByteCountFormatter.string(fromByteCount: freeSpace, countStyle: .file)
                } else {
                    return -1
                }
            }
        )
    }
    
    func getTotalDiskSpace() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getTotalDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: -1,
            function: {
                if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
                   let totalSpace = attributes[.systemSize] as? Int64 {
                    return CLong(totalSpace)
                    //                   return ByteCountFormatter.string(fromByteCount: totalSpace, countStyle: .file)
                } else {
                    return -1
                }
            }
        )
    }
    
    func getUsedDiskSpace() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getUsedDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: -1,
            function: {
                let fileManager = FileManager.default
                let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
                if let totalSpace = attributes[.systemSize] as? NSNumber,
                   let freeSpace = attributes[.systemFreeSize] as? NSNumber {
                    let usedSpace = totalSpace.int64Value - freeSpace.int64Value
                    return CLong(usedSpace)
                    //                    return ByteCountFormatter.string(fromByteCount: usedSpace, countStyle: .file)
                } else {
                    return -1
                }
                
            }
        )
    }
    
    
    func getDeviceModel() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getDeviceModel",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.model
            }
        )
    }
    
    func getDeviceName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getDeviceName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.name
            }
        )
    }
    
    func getWifiIPAddress() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getWifiIPAddress",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var address: String?
                var ifaddr: UnsafeMutablePointer<ifaddrs>?
                
                if getifaddrs(&ifaddr) == 0 {
                    var ptr = ifaddr
                    while ptr != nil {
                        defer { ptr = ptr?.pointee.ifa_next }
                        
                        let interface = ptr?.pointee
                        let addrFamily = interface?.ifa_addr.pointee.sa_family
                        
                        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6),
                           let name = interface?.ifa_name,
                           String(cString: name) == "en0",
                           let addr = interface?.ifa_addr {
                            
                            let host = UnsafeMutablePointer<Int8>.allocate(capacity: Int(NI_MAXHOST))
                            defer { host.deallocate() }
                            
                            if getnameinfo(addr, socklen_t(addr.pointee.sa_len), host, socklen_t(NI_MAXHOST), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                                address = String(cString: host)
                            }
                        }
                    }
                    freeifaddrs(ifaddr)
                }
                
                return address ?? "Unable to retrieve IP address"
            }
        )
    }
    
    func getDisplayScale() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayScale",
            requestId: UUID().uuidString,
            defaultValue: 1.0,
            function: {
                return await Float(UIScreen.main.scale)
            }
        )
    }
    
    func getDisplayWidth() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayWidth",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                return await Float(UIScreen.main.bounds.size.height)
            }
        )
    }
    
    func getDisplayHeight() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayHeight",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                return await Float(UIScreen.main.bounds.size.width)
            }
        )
    }
    
    func getTimeZone() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getTimeZone",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return TimeZone.current.identifier
            }
        )
    }
    
    func getCurrentTime() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getCurrentTime",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                return Utils.dateToUnixTimestamp(Date())
            }
        )
    }
    
    func getCurrentLocal() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCurrentLocal",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                dateFormatter.timeStyle = .full
                return dateFormatter.string(from: Date())
            }
        )
    }
    
    func getPreferredLanguage() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getPreferredLanguage",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Locale.preferredLanguages.first ?? "Unknown"
            }
        )
    }
    
    func getSandboxPath() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getSandboxPath",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return NSHomeDirectory()
            }
        )
    }
    
    func getMobileCountryCode() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getMobileCountryCode",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
                    return carrier.mobileCountryCode ?? "Unknown"
                }
                return "Unknown"
            }
        )
    }
    
    
    func getNetworkCountryCode() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getNetworkCountryCode",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
                    return carrier.mobileNetworkCode ?? "Unknown"
                }
                return "Unknown"
            }
        )
    }
    
    func getHostName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getHostName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return ProcessInfo.processInfo.hostName
            }
        )
    }
    
    
    func isiOSAppOnMac() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "isiOSAppOnMac",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                if #available(iOS 14.0, *) {
                    return ProcessInfo.processInfo.isiOSAppOnMac
                } else {
                    return false
                }
            }
        )
    }
    
    func getOrientation() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getOrientation",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let deviceOrientation = await UIDevice.current.orientation
                
                let interfaceOrientation: UIInterfaceOrientation?
                if #available(iOS 15, *) {
                    if let windowScene = await UIApplication.shared.connectedScenes
                        .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                        interfaceOrientation = await windowScene.interfaceOrientation
                    } else {
                        interfaceOrientation = nil
                    }
                } else {
                    if let window = await UIApplication.shared.windows.first,
                       let windowScene = await window.windowScene {
                        interfaceOrientation = await windowScene.interfaceOrientation
                    } else {
                        interfaceOrientation = nil
                    }
                }
                
                let orientation: String
                switch interfaceOrientation {
                case .portrait:
                    orientation = "Portrait"
                case .portraitUpsideDown:
                    orientation = "Portrait Upside Down"
                case .landscapeLeft:
                    orientation = "Landscape Left"
                case .landscapeRight:
                    orientation = "Landscape Right"
                default:
                    // Fallback to device orientation if interface orientation is nil
                    switch deviceOrientation {
                    case .portrait:
                        orientation = "Portrait"
                    case .portraitUpsideDown:
                        orientation = "Portrait Upside Down"
                    case .landscapeLeft:
                        orientation = "Landscape Left"
                    case .landscapeRight:
                        orientation = "Landscape Right"
                    case .faceUp:
                        orientation = "Face Up"
                    case .faceDown:
                        orientation = "Face Down"
                    default:
                        orientation = "Unknown"
                    }
                }
                
                return orientation
            }
        )
    }
    
    func getCarrierName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCarrierName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
                    return carrier.carrierName ?? "Unknown"
                }
                return "Unknown"
            }
        )
    }
    
    func getNetworkType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getNetworkType",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await withCheckedContinuation { continuation in
                    let monitor = NWPathMonitor()
                    let queue = DispatchQueue(label: "NetworkMonitor")
                    
                    monitor.pathUpdateHandler = { path in
                        var networkType = "Unknown"
                        if path.status == .satisfied {
                            if path.usesInterfaceType(.wifi) {
                                networkType = "Wifi"
                            } else if path.usesInterfaceType(.cellular) {
                                networkType = "Cellular"
                            } else if path.usesInterfaceType(.wiredEthernet) {
                                networkType = "Ethernet"
                            } else if path.usesInterfaceType(.loopback) {
                                networkType = "Loopback interface"
                            } else if path.usesInterfaceType(.other) {
                                networkType = "Connected via other network interface (possibly VPN)"
                            }
                        } else {
                            networkType = "Unknown"
                        }
                        monitor.cancel()
                        continuation.resume(returning: networkType)
                    }
                    
                    monitor.start(queue: queue)
                }
                
            }
        )
    }
    
    func getSystemUptime() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getSystemUptime",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                return CLong(ProcessInfo.processInfo.systemUptime)
            }
        )
    }
    
    func getRAMUsage() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getRAMUsage",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var taskInfo = mach_task_basic_info()
                var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
                let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
                    }
                }
                
                if kerr == KERN_SUCCESS {
                    return Utils.formatBytes(Int64(taskInfo.resident_size))
                } else {
                    return "Unknown"
                }
            }
        )
    }
    
    func getTotalRAMSize() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getTotalRAMSize",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var size: UInt64 = 0
                let HOST_VM_INFO_COUNT = MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size
                var vmStats = vm_statistics64()
                var count = mach_msg_type_number_t(HOST_VM_INFO_COUNT)
                let result = withUnsafeMutablePointer(to: &vmStats) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: HOST_VM_INFO_COUNT) {
                        host_statistics64(mach_host_self(), HOST_VM_INFO, $0, &count)
                    }
                }
                
                if result == KERN_SUCCESS {
                    let pageSize = vm_kernel_page_size
                    size = UInt64(vmStats.wire_count + vmStats.active_count + vmStats.inactive_count + vmStats.free_count) * UInt64(pageSize)
                    return Utils.formatBytes(Int64(size))
                } else {
                    return "Error retrieving RAM size"
                }
            }
        )
    }
    
    func getKernelVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var size: Int = 0
                sysctlbyname("kern.version", nil, &size, nil, 0)
                var name = [CChar](repeating: 0, count: size)
                sysctlbyname("kern.version", &name, &size, nil, 0)
                return String(cString: name)
            }
        )
    }
    
    func getKernelOSVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelOSVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var size: Int = 0
                sysctlbyname("kern.osversion", nil, &size, nil, 0)
                var version = [CChar](repeating: 0, count: size)
                sysctlbyname("kern.osversion", &version, &size, nil, 0)
                return String(cString: version)
            }
        )
    }
    
    func getKernelOSRelease() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelOSRelease",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var size: Int = 0
                sysctlbyname("kern.osrelease", nil, &size, nil, 0)
                var release = [CChar](repeating: 0, count: size)
                sysctlbyname("kern.osrelease", &release, &size, nil, 0)
                return String(cString: release)
            }
        )
    }
    
    func getKernelOSType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelOSType",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var size: Int = 0
                sysctlbyname("kern.ostype", nil, &size, nil, 0)
                var osType = [CChar](repeating: 0, count: size)
                sysctlbyname("kern.ostype", &osType, &size, nil, 0)
                return String(cString: osType)
            }
        )
    }
    
    func getiOSVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getiOSVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.systemVersion
            }
        )
    }
    
    
    func getFrameworkVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getFrameworkVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleShortVersionString"] as? String
                return version ?? "Unknown"
            }
        )
    }
    
    
    func getiOSAppVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getiOSAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    return version
                } else {
                    return "Unknown"
                }
            }
        )
    }
    
    
    func getAppName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Unknown"
            }
        )
    }
    
    func getAppInstallTime() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getAppInstallTime",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                let userDefaults = UserDefaults.standard
                let installDateKey = "AppInstallDate"
                
                if let installDate = userDefaults.object(forKey: installDateKey) as? Date {
                    return Utils.dateToUnixTimestamp(installDate)
                } else {
                    // If it's the first time launching the app, save the current date as the install date
                    let installDate = Date()
                    userDefaults.set(installDate, forKey: installDateKey)
                    return Utils.dateToUnixTimestamp(installDate)
                }
            }
        )
    }
    
    
    func getAppUpdateTime() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getAppUpdateTime",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                let userDefaults = UserDefaults.standard
                let updateDateKey = "AppUpdateDate"
                let currentVersionKey = "AppVersion"
                
                if let storedVersion = userDefaults.string(forKey: currentVersionKey),
                   let storedUpdateDate = userDefaults.object(forKey: updateDateKey) as? Date,
                   storedVersion == Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    return Utils.dateToUnixTimestamp(storedUpdateDate)
                } else {
                    // The app has been updated, save the current date as the update date
                    let updateDate = Date()
                    let currentVersion = await getiOSAppVersion()
                    userDefaults.set(updateDate, forKey: updateDateKey)
                    userDefaults.set(currentVersion, forKey: currentVersionKey)
                    return Utils.dateToUnixTimestamp(updateDate)
                }
            }
        )
    }
    
    func getAppState() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppState",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let state = await UIApplication.shared.applicationState
                switch state {
                case .active:
                    return "Foreground"
                case .background:
                    return "Background"
                case .inactive:
                    return "Inactive"
                @unknown default:
                    return "Unknown"
                }
            }
        )
    }
    
    
    func getAppBuildNumber() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppBuildNumber",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    return buildNumber
                } else {
                    return "Unknown"
                }
            }
        )
    }
    
    func getFrameworkBuildNumber() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getFrameworkBuildNumber",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3SDK.self).infoDictionary?["CFBundleVersion"] as? String
                return version ?? "Unknown"
            }
        )
    }
    
    
    func getLocation() async -> Location {
        return await Utils.getDeviceSignals(
            functionName: "getLatLong",
            requestId: UUID().uuidString,
            defaultValue: Location(latitude: 0.0, longitude: 0.0, altitude: 0.0, timeStamp: 0),
            function: {
                /// Check if location permission is granted
                if await UIApplication.shared.applicationState == .background {
                    guard Utils.hasBackgroundLocationPermission() else {
                        Log.e("Permission Denied", "Background Location permission not granted")
                        return Location(latitude: 0.0, longitude: 0.0, altitude: 0.0, timeStamp: 1)
                    }
                } else {
                    guard Utils.hasForegroundLocationPermission() else {
                        Log.e("Permission Denied", "Foreground Location permission not granted")
                        return Location(latitude: 0.0, longitude: 0.0, altitude: 0.0, timeStamp: 2)
                    }
                }
                
                do {
                    let location = try await getUpdatedLocation()
                    let latitude = await location.latitude
                    let longitude = await location.longitude
                    let altitude = await location.altitude
                    let timeStamp = await location.timeStamp
                    
                    return Location(
                        latitude: latitude,
                        longitude: longitude,
                        altitude: altitude,
                        timeStamp: timeStamp
                    )
                } catch {
                    Log.e("Location Error", "Failed to fetch location: \(error.localizedDescription)")
                    return Location(latitude: 0.0, longitude: 0.0, altitude: 0.0, timeStamp: 3)
                }
            }
        )
    }
    
    private func getUpdatedLocation() async throws -> Location {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                var hasResumed = false
                let defaultLocation = Location(
                    latitude: 0.0,
                    longitude: 0.0,
                    altitude: 0.0,
                    timeStamp: 4)
                
                /// Getting current location
                LocationFramework.shared.startUpdatingLocation { location in
                    /// Prevent duplicate resumes
                    guard !hasResumed else { return }
                    
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    let altitude = location.altitude
                    let timeStamp = location.timestamp
                    LocationFramework.shared.stopUpdatingLocation()
                    
                    /// Mark continuation as resumed and return the result
                    hasResumed = true
                    continuation.resume(returning: Location(
                        latitude: latitude,
                        longitude: longitude,
                        altitude: altitude,
                        timeStamp: Utils.dateToUnixTimestamp(timeStamp)
                    ))
                    return
                }
                
                /// This code executes when the app goes into the background. It waits for 10 seconds to get the current location, if the location is not obtained, it returns the default location.
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    /// Prevent duplicate resumes
                    guard !hasResumed else { return }
                    hasResumed = true
                    continuation.resume(returning: defaultLocation)
                }
            }
        }
    }

    
    func isTelephonySupported() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "isTelephonySupported",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
                    return carrier.carrierName != nil
                }
                return false
            }
        )
    }
    
    func getCameraList() async -> [String] {
        return await Utils.getDeviceSignals(
            functionName: "getCameraList",
            requestId: UUID().uuidString,
            defaultValue: [],
            function: {
                var cameraList: [String] = []
                
                // Create a discovery session to find available cameras
                let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera], mediaType: .video, position: .unspecified).devices
                
                // Iterate over each device and gather its information
                for device in devices {
                    let cameraInfo = "Name: \(device.localizedName), Type: \(device.deviceType)"
                    cameraList.append(cameraInfo)
                }
                
                return cameraList
            }
        )
    }
    
    func getAbiType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAbiType",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var systemInfo = utsname()
                uname(&systemInfo)
                
                let machine = withUnsafePointer(to: &systemInfo.machine) {
                    $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                        String(cString: $0)
                    }
                }
                
                switch machine {
                case "x86_64":
                    return "x86_64 (Simulator)"
                case "i386":
                    return "i386 (Simulator)"
                case "arm64":
                    return "arm64 (Device)"
                case "armv7":
                    return "armv7 (Device)"
                case "armv6":
                    return "armv6 (Device)"
                case "armv7s":  // ARMv7s (used in devices like iPhone 5, iPad Mini)
                    return "armv7s (Device)"
                case "arm64e":  // ARM64e (used in newer devices like iPhone XS and later)
                    return "arm64e (Device)"
                default:
                    return machine
                }
            }
        )
    }
    
    func getRingtoneSource() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getRingtoneSource",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let audioSession = AVAudioSession.sharedInstance()
                let currentRoute = audioSession.currentRoute
                let outputs = currentRoute.outputs
                
                for output in outputs {
                    if output.portType == .builtInSpeaker {
                        return "Built-in Speaker"
                    } else if output.portType == .headphones {
                        return "Headphones"
                    } else if output.portType == .headsetMic {
                        return "Headset Mic"
                    }
                }
                
                return "Unknown"
            }
        )
    }
    
    func getAvailableLocales() async -> [String] {
        return await Utils.getDeviceSignals(
            functionName: "getAvailableLocales",
            requestId: UUID().uuidString,
            defaultValue: [],
            function: {
                return Locale.availableIdentifiers
            }
        )
    }
    
    func getSecurityProvidersData() async -> [String] {
        return await Utils.getDeviceSignals(
            functionName: "getSecurityProvidersData",
            requestId: UUID().uuidString,
            defaultValue: [],
            function: {
                let context = LAContext()
                var error: NSError?
                
                var providers = [String]()
                
                if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                    providers.append("Passcode Authentication")
                }
                
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    switch context.biometryType {
                    case .faceID:
                        providers.append("Face ID Authentication")
                    case .touchID:
                        providers.append("Touch ID Authentication")
                    default:
                        break
                    }
                }
                
                return providers.isEmpty ? ["No security lock is set on this device"] : providers
            }
        )
    }
    
    
    func getFingerPrintSensorStatus() async -> [String] {
        return await Utils.getDeviceSignals(
            functionName: "getFingerPrintSensorStatus",
            requestId: UUID().uuidString,
            defaultValue: [],
            function: {
                let context = LAContext()
                var error: NSError?
                var status = [String]()
                
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    if context.biometryType == .faceID {
                        status.append("Face ID available")
                    }
                    if context.biometryType == .touchID {
                        status.append("Touch ID available")
                    }
                    
                    // If both Face ID and Touch ID are available
                    if status.isEmpty {
                        status.append("Biometric authentication not available")
                    }
                } else {
                    status.append("Biometric authentication not available")
                }
                
                return status
            }
        )
    }
    
    func getGlesVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getGlesVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let device = MTLCreateSystemDefaultDevice()
                return device?.name ?? "Unknown"
            }
        )
    }
    
    func isDevelopmentSettingsEnabled() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "isDevelopmentSettingsEnabled",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
#if DEBUG
                return true
#else
                return false
#endif
            }
        )
    }
    
    func getHttpProxy() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getHttpProxy",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
                   let httpProxy = proxySettings["HTTPProxy"] as? String {
                    return "HTTP Proxy Found: \(httpProxy)"
                } else {
                    return "No HTTP Proxy"
                }
            }
        )
    }
    
    func getAccessibilitySettings() async -> [String] {
        return await Utils.getDeviceSignals(
            functionName: "getAccessibilitySettings",
            requestId: UUID().uuidString,
            defaultValue: [],
            function: {
                //  UIKit APIs like UIAccessibility must be accessed on the main thread, but they are being calledoff the main thread in your asynchronous code. UIKit is not thread-safe, so these calls should always be made from the main thread.
                return await withCheckedContinuation { continuation in
                    DispatchQueue.main.async {
                        var settings = [String]()
                        
                        if UIAccessibility.isVoiceOverRunning {
                            settings.append("VoiceOver is running")
                        }
                        
                        if UIAccessibility.isReduceMotionEnabled {
                            settings.append("Reduce Motion is enabled")
                        }
                        
                        if UIAccessibility.isInvertColorsEnabled {
                            settings.append("Invert Colors is enabled")
                        }
                        
                        if UIAccessibility.isBoldTextEnabled {
                            settings.append("Bold Text is enabled")
                        }
                        
                        if UIAccessibility.isReduceTransparencyEnabled {
                            settings.append("Reduce Transparency is enabled")
                        }
                        
                        if UIAccessibility.isClosedCaptioningEnabled {
                            settings.append("Closed Captions are enabled")
                        }
                        
                        if UIAccessibility.isSpeakScreenEnabled {
                            settings.append("Speak Screen is enabled")
                        }
                        
                        if UIAccessibility.isAssistiveTouchRunning {
                            settings.append("Assistive touch is running")
                        }
                        
                        if #available(iOS 14.0, *) {
                            if UIAccessibility.buttonShapesEnabled {
                                settings.append("Button shapes are enabled")
                            }
                        }
                        
                        if UIAccessibility.isDarkerSystemColorsEnabled {
                            settings.append("Darker system colors are enabled")
                        }
                        
                        if UIAccessibility.isGrayscaleEnabled {
                            settings.append("Grayscale is enabled")
                        }
                        
                        if UIAccessibility.isGuidedAccessEnabled {
                            settings.append("Guided access is enabled")
                        }
                        
                        if UIAccessibility.isMonoAudioEnabled {
                            settings.append("Mono audio is enabled")
                        }
                        
                        if UIAccessibility.isOnOffSwitchLabelsEnabled {
                            settings.append("On off switch labels are enabled")
                        }
                        
                        if UIAccessibility.isShakeToUndoEnabled {
                            settings.append("Shake to undo is enabled")
                        }
                        
                        if UIAccessibility.isSpeakSelectionEnabled {
                            settings.append("Speak selection is enabled")
                        }
                        
                        if UIAccessibility.isSwitchControlRunning {
                            settings.append("Switch control is running")
                        }
                        
                        if UIAccessibility.isVideoAutoplayEnabled {
                            settings.append("Video autoplay is enabled")
                        }
                        
                        continuation.resume(returning: settings.isEmpty ? ["Not found any Accessibility service on this device"] : settings)
                    }
                }
            }
        )
    }
    
    func isTouchExplorationEnabled() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "isTouchExplorationEnabled",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                return await UIAccessibility.isVoiceOverRunning
            }
        )
    }
    
    func getAlarmAlertPath() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAlarmAlertPath",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let soundURL = Bundle.main.url(forResource: "alarmSound", withExtension: "mp3") {
                    return soundURL.path
                } else {
                    return "Not found any Alarm alert path"
                }
            }
        )
    }
    
    func getTime12Or24() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getTime12Or24",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.timeStyle = .short
                let sampleDate = Date()
                let formattedDate = formatter.string(from: sampleDate)
                let is24HourFormat = !formattedDate.contains("AM") && !formattedDate.contains("PM")
                return is24HourFormat ? "24-hour format" : "12-hour format"
            }
        )
    }
    
    func getFontScale() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getFontScale",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
                let scaledFont = UIFontMetrics.default.scaledFont(for: font)
                return Float(scaledFont.pointSize / UIFont.systemFontSize)
            }
        )
    }
    
    func getTextAutoReplace() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "getTextAutoReplace",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                let userDefaults = UserDefaults.standard
                if let autoReplaceSetting = userDefaults.object(forKey: "TextInput.AutoReplace") as? Bool {
                    return autoReplaceSetting
                }
                return false
            }
        )
    }
    
    func getTextAutoPunctuate() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "getTextAutoPunctuate",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                let userDefaults = UserDefaults.standard
                if let autoPunctuateSetting = userDefaults.object(forKey: "TextInput.AutoPunctuate") as? Bool {
                    return autoPunctuateSetting
                }
                return false
            }
        )
    }
    
    func getBootTime() async -> CLong {
        return await Utils.getDeviceSignals(
            functionName: "getBootTime",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
                var size = MemoryLayout<timeval>.size
                var bootTime = timeval()
                
                let result = sysctl(&mib, UInt32(mib.count), &bootTime, &size, nil, 0)
                
                if result == 0 {
                    let bootDate = Date(timeIntervalSince1970: TimeInterval(bootTime.tv_sec) + TimeInterval(bootTime.tv_usec) / 1_000_000)
                    return Utils.dateToUnixTimestamp(bootDate)
                } else {
                    return 0
                }
            }
        )
    }
    
    func getCurrentBrightness() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getCurrentBrightness",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                return await Float(UIScreen.main.brightness)
            }
        )
    }
    
    func getSimInfoList() async -> [String : String] {
        return await Utils.getDeviceSignals(
            functionName: "getSimInfoList",
            requestId: UUID().uuidString,
            defaultValue: ["" : ""],
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                var simInfo = [String: String]()
                
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.values.first {
                    simInfo["CarrierName"] = carrier.carrierName ?? "Unknown"
                    simInfo["MobileCountryCode"] = carrier.mobileCountryCode ?? "Unknown"
                    simInfo["MobileNetworkCode"] = carrier.mobileNetworkCode ?? "Unknown"
                    simInfo["ISOCode"] = carrier.isoCountryCode ?? "Unknown"
                    simInfo["AllowsVOIP"] = carrier.allowsVOIP ? "Yes" : "No"
                }
                
                return simInfo
            }
        )
    }
    
    func getDefaultBrowser() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getDefaultBrowser",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if await UIApplication.shared.canOpenURL(URL(string: "googlechrome://")!) {
                    return "Google Chrome"
                } else {
                    return "Safari"
                }
            }
        )
    }
    
    func getAudioVolumeCurrent() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getAudioVolumeCurrent",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                let audioSession = AVAudioSession.sharedInstance()
                let currentVolume = audioSession.outputVolume
                return currentVolume
            }
        )
    }
    
    func getCarrierCountry() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCarrierCountry",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceSubscriberCellularProviders?.first?.value {
                    return carrier.isoCountryCode ?? "Unknown"
                }
                return "Unknown"
            }
        )
    }
    
    
    func isDebuggerEnabled() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "checkDebug",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                var debug = false
                
                // Define the kinfo_proc structure in Swift
                var info = kinfo_proc()
                var size = MemoryLayout<kinfo_proc>.size
                
                // Define the sysctl MIB array
                let mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, Int32(getpid())]
                
                // Call sysctl
                let status = mib.withUnsafeBufferPointer { mibPointer -> Int32 in
                    // Convert mibPointer to UnsafeMutablePointer
                    let mibMutablePointer = UnsafeMutablePointer<Int32>(mutating: mibPointer.baseAddress!)
                    // Pass size as UnsafeMutablePointer
                    return withUnsafeMutablePointer(to: &size) { sizePointer in
                        sysctl(mibMutablePointer, UInt32(mibPointer.count), &info, sizePointer, nil, 0)
                    }
                }
                
                // Check if sysctl call was successful
                if status == 0 {
                    debug = (info.kp_proc.p_flag & P_TRACED) != 0
                } else {
                    // Handle the case where sysctl fails
                    print("sysctl call failed with status \(status)")
                }
                
                // Check isatty
                if !debug {
                    debug = isatty(STDOUT_FILENO) != 0
                }
                
                return debug
            }
        )
    }
    
    func checkBuildConfiguration() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "checkBuildConfiguration",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
#if DEBUG
                return "Debug"
#else
                return "Release"
#endif
            }
        )
        
    }
    
    func getCPUType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCPUType",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                var cpuType: cpu_type_t = 0
                var size = MemoryLayout<cpu_type_t>.size
                sysctlbyname("hw.cputype", &cpuType, &size, nil, 0)
                
                switch cpuType {
                case CPU_TYPE_ARM:
                    return "ARM CPU"
                case CPU_TYPE_ARM64:
                    return "ARM64 CPU"
                case CPU_TYPE_X86:
                    return "x86 CPU"
                case CPU_TYPE_X86_64:
                    return "x86_64 CPU"
                default:
                    return "Unknown CPU"
                }
            }
        )
    }
    
    
    func hasProximitySensor() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "hasProximitySensor",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                let device = await UIDevice.current
                return await device.isProximityMonitoringEnabled
            }
        )
    }
    
    
    func getLocalizedModel() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getLocalizedModel",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.localizedModel
            }
        )
    }
    
    
    func getSystemName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getSystemName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.systemName
            }
        )
    }
    
    func getMacAddress() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getMacAddress",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let deviceSignalsApiImplObjC = DeviceSignalsApiImplObjC()
                return deviceSignalsApiImplObjC.getMacAddress()
            }
        )
    }
    
    
    func getIPhoneBluetoothMacAddress() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getIPhoneBluetoothMacAddress",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let deviceSignalsApiImplObjC = DeviceSignalsApiImplObjC()
                return deviceSignalsApiImplObjC.getIPhoneBluetoothMacAddress()
            }
        )
    }
    
    func getIPadBluetoothMacAddress() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getIPadBluetoothMacAddress",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                //                Utils.showInfologs(tags: "TAG_UUID", value: DeviceSignalsApiImplObjC().getDeviceUUID())
                let deviceSignalsApiImplObjC = DeviceSignalsApiImplObjC()
                return deviceSignalsApiImplObjC.getIPadBluetoothMacAddress()
            }
        )
    }
    
    func lockDownMode() async -> Bool {
        return await Utils.getDeviceSignals(
            functionName: "lockdownMode",
            requestId: UUID().uuidString,
            defaultValue: false,
            function: {
                return UserDefaults.standard.bool(forKey: "LDMGlobalEnabled")
            }
        )
    }
    
    func getWifiSSID() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getWifiSSID",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let interfaces = CNCopySupportedInterfaces() as? [String] {
                    for interface in interfaces {
                        if let networkInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject],
                           let currentSSID = networkInfo["SSID"] as? String {
                            return currentSSID
                        }
                    }
                }
                return "Unknown SSID"
            }
        )
    }
    
    
}
