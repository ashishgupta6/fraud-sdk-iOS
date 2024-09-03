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


public class DeviceSignalsApiImpl : DeviceSignalsApi{
    
    public init() {}
    
    public func getiOSDeviceId() async -> String {
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
    
    public func getIDFA() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getIDFA",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
                } else {
                    return "IDFA is not available"
                }
            }
        )
    }
    
    public func getIDFV() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getIDFV",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                guard let idfv = await UIDevice.current.identifierForVendor?.uuidString else {
                    return "Unable to get IDFV"
                }
                return idfv
            }
        )
    }
    
    public func getUUID() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getUUID",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                UUID().uuidString
            }
        )
    }
    
    public func getCloudId() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCloudId",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                // Implement actual logic to retrieve Cloud ID if available
                return "Cloud ID is not available"
            }
        )
    }
    
    public func getApplicationId() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getApplicationId",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Bundle.main.bundleIdentifier ?? "Unknown"
            }
        )
    }
    
    public func getBatteryStatus() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getBatteryStatus",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                await fetchBatteryStatus()
            }
        )
    }
    
    private func fetchBatteryStatus() async -> String {
        // Perform the UIDevice.current access and mutation on the main actor
        return await MainActor.run {
            let device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            switch device.batteryState {
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
    }
    
    public func getBatteryLevel() async -> Float {
        return await Utils.getDeviceSignals(
            functionName: "getBatteryLevel",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                await fetchBatteryLevel()
            }
        )
    }
    
    private func fetchBatteryLevel() async -> Float {
        // Perform the UIDevice.current access and mutation on the main actor
        return await MainActor.run {
            let device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            return device.batteryLevel
        }
    }
    
    public func getCpuCount() async -> Int {
        return await Utils.getDeviceSignals(
            functionName: "getCpuCount",
            requestId: UUID().uuidString,
            defaultValue: 0,
            function: {
                return ProcessInfo.processInfo.activeProcessorCount
            }
        )
    }
    
    
    public func getFreeDiskSpace() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getTotalDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
                   let totalSpace = attributes[.systemSize] as? Int64 {
                    return ByteCountFormatter.string(fromByteCount: totalSpace, countStyle: .file)
                } else {
                    return "Unable to retrieve total disk space"
                }
            }
        )
    }
    
    public func getTotalDiskSpace() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getFreeDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
                   let freeSpace = attributes[.systemFreeSize] as? Int64 {
                    return ByteCountFormatter.string(fromByteCount: freeSpace, countStyle: .file)
                } else {
                    return "Unable to retrieve free disk space"
                }
            }
        )
    }
    
    public func getUsedDiskSpace() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getUsedDiskSpace",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let fileManager = FileManager.default
                let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
                if let totalSpace = attributes[.systemSize] as? NSNumber,
                   let freeSpace = attributes[.systemFreeSize] as? NSNumber {
                    let usedSpace = totalSpace.int64Value - freeSpace.int64Value
                    return ByteCountFormatter.string(fromByteCount: usedSpace, countStyle: .file)
                } else {
                    return "Unable to retrieve used disk space"
                }
                
            }
        )
    }
    
    
    public func getDeviceModel() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getDeviceModel",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.model
            }
        )
    }
    
    public func getDeviceName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getDeviceName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.name
            }
        )
    }
    
    public func getWifiMacAddress() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getWiFiIPAddress",
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
    
    public func getDisplayScale() async -> CGFloat {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayScale",
            requestId: UUID().uuidString,
            defaultValue: 1.0,
            function: {
                return await UIScreen.main.scale
            }
        )
    }
    
    public func getDisplayWidth() async -> CGFloat {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayHeight",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                return await UIScreen.main.bounds.size.height
            }
        )
    }
    
    public func getDisplayHeight() async -> CGFloat {
        return await Utils.getDeviceSignals(
            functionName: "getDisplayWidth",
            requestId: UUID().uuidString,
            defaultValue: 0.0,
            function: {
                return await UIScreen.main.bounds.size.width
            }
        )
    }
    
    public func getTimeZone() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getTimeZone",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return TimeZone.current.identifier
            }
        )
    }
    
    public func getCurrentTime() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getCurrentTime",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return dateFormatter.string(from: Date())
            }
        )
    }
    
    public func getCurrentLocal() async -> String {
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
    
    public func getPreferredLanguage() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getPreferredLanguage",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Locale.preferredLanguages.first ?? "Unknown"
            }
        )
    }
    
    public func getSandboxPath() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getSandboxPath",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return NSHomeDirectory()
            }
        )
    }
    
    public func getMobileCountryCode() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getMCC",
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
    
    
    public func getNetworkCountryCode() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getMNC",
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
    
    public func getHostName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getHostName",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return ProcessInfo.processInfo.hostName
            }
        )
    }
    
    
    public func isiOSAppOnMac() async -> Bool {
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
    
    public func getOrientation() async -> String {
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
    
    public func getCarrierName() async -> String {
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
    
    public func getNetworkType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getNetworkType",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value {
                    return carrier
                }
                return "Unknown"
            }
        )
    }
    
    public func getSystemUptime() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getSystemUptime",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let uptime = ProcessInfo.processInfo.systemUptime
                let timeInterval = TimeInterval(uptime)
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                return formatter.string(from: timeInterval) ?? "Unknown"
            }
        )
    }
    
    public func getRAMUsage() async -> String {
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
    
    public func getTotalRAMSize() async -> String {
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
    
    public func getKernelVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelName",
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
    
    public func getKernelOSVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelVersion",
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
    
    public func getKernelOSRelease() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelVersion",
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
    
    public func getKernelOSType() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getKernelVersion",
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
    
    public func getiOSVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getiOSVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return await UIDevice.current.systemVersion
            }
        )
    }
    
    
    public func getFrameworkVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getFrameworkVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3Intelligence.self).infoDictionary?["CFBundleShortVersionString"] as? String
                return version ?? "Unknown"
            }
        )
    }
    
    
    public func getiOSAppVersion() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
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
    
    
    public func getAppName() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Unknown"
            }
        )
    }
    
    public func getAppInstallTime() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let userDefaults = UserDefaults.standard
                let installDateKey = "AppInstallDate"
                
                if let installDate = userDefaults.object(forKey: installDateKey) as? Date {
                    return Utils.dateToString(installDate)
                } else {
                    // If it's the first time launching the app, save the current date as the install date
                    let installDate = Date()
                    userDefaults.set(installDate, forKey: installDateKey)
                    return Utils.dateToString(installDate)
                }
            }
        )
    }
    
    
    public func getAppUpdateTime() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let userDefaults = UserDefaults.standard
                let updateDateKey = "AppUpdateDate"
                let currentVersionKey = "AppVersion"
                
                if let storedVersion = userDefaults.string(forKey: currentVersionKey),
                   let storedUpdateDate = userDefaults.object(forKey: updateDateKey) as? Date,
                   storedVersion == Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    return Utils.dateToString(storedUpdateDate)
                } else {
                    // The app has been updated, save the current date as the update date
                    let updateDate = Date()
                    let currentVersion = await getiOSAppVersion()
                    userDefaults.set(updateDate, forKey: updateDateKey)
                    userDefaults.set(currentVersion, forKey: currentVersionKey)
                    return Utils.dateToString(updateDate)
                }
            }
        )
    }
    
    public func getAppState() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
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
    
    
    public func getAppBuildNumber() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
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
    
    public func getFrameworkBuildNumber() async -> String {
        return await Utils.getDeviceSignals(
            functionName: "getAppVersion",
            requestId: UUID().uuidString,
            defaultValue: "Unknown",
            function: {
                let version = Bundle(for: Sign3Intelligence.self).infoDictionary?["CFBundleVersion"] as? String
                return version ?? "Unknown"
            }
        )
    }
    
}
