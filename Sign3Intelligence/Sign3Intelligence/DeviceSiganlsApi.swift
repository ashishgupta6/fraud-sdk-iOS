//
//  DeviceSiganlsApi.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 07/08/24.
//

import Foundation

protocol DeviceSignalsApi{
    
    func getiOSDeviceId() async -> String
    func getIDFA() async -> String
    func getIDFV() async -> String
    func getUUID() async -> String
    func getCloudId() async -> String
    func getApplicationId() async -> String
    func getBatteryStatus() async -> String
    func getBatteryLevel() async -> Float
    func getCpuCount() async -> Int
    func getTotalDiskSpace() async -> String
    func getFreeDiskSpace() async -> String
    func getUsedDiskSpace() async -> String
    func getDeviceModel() async -> String
    func getDeviceName() async -> String
    func getIPAddress() async -> String
    func getDisplayWidth() async -> CGFloat
    func getDisplayHeight() async -> CGFloat
    func getDisplayScale() async -> CGFloat
    func getTimeZone() async -> String
    func getCurrentTime() async -> String
    func getCurrentLocal() async -> String
    func getPreferredLanguage() async -> String
    func getSandboxPath() async -> String
    func getMobileCountryCode() async -> String
    func getNetworkCountryCode() async -> String
    func getHostName() async -> String
    func isiOSAppOnMac() async -> Bool
    func getOrientation() async -> String
    func getCarrierName() async -> String
    func getNetworkType() async -> String
    func getSystemUptime() async -> String
    func getRAMUsage() async -> String
    func getTotalRAMSize() async -> String
    func getKernelVersion() async -> String
    func getKernelOSVersion() async -> String
    func getKernelOSRelease() async -> String
    func getKernelOSType() async -> String
    func getiOSVersion() async -> String
    func getFrameworkVersion() async -> String
    func getiOSAppVersion() async -> String
    func getAppName() async -> String
    func getAppInstallTime() async -> String
    func getAppUpdateTime() async -> String
    func getAppState() async -> String
    func getAppBuildNumber() async -> String
    func getFrameworkBuildNumber() async -> String
    func getLatLong() async -> Location
    
}
