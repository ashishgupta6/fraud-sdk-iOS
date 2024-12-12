//
//  DeviceSiganlsApi.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 07/08/24.
//

import Foundation

internal protocol DeviceSignalsApi{
    
    func getiOSDeviceId() async -> String
    func getIDFA() async -> String
    func getCloudId() async -> String
    func getApplicationId() async -> String
    func getBatteryStatus() async -> String
    func getBatteryLevel() async -> Float
    func getCpuCount() async -> Int
    func getTotalDiskSpace() async -> CLong
    func getFreeDiskSpace() async -> CLong
    func getUsedDiskSpace() async -> CLong
    func getDeviceModel() async -> String
    func getDeviceName() async -> String
    func getWifiIPAddress() async -> String
    func getDisplayWidth() async -> Float
    func getDisplayHeight() async -> Float
    func getDisplayScale() async -> Float
    func getTimeZone() async -> String
    func getCurrentTime() async -> CLong
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
    func getSystemUptime() async -> CLong
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
    func getAppInstallTime() async -> CLong
    func getAppUpdateTime() async -> CLong
    func getAppState() async -> String
    func getAppBuildNumber() async -> String
    func getFrameworkBuildNumber() async -> String
    func getLocation() async -> Location
    func isTelephonySupported() async -> Bool
    func getCameraList() async -> [String] 
    func getAbiType() async -> String
    func getRingtoneSource() async -> String
    func getAvailableLocales() async -> [String]
    func getSecurityProvidersData() async -> [String]
    func getFingerPrintSensorStatus() async -> [String]
    func getGlesVersion() async -> String
    func isDevelopmentSettingsEnabled() async -> Bool
    func getHttpProxy() async -> String
    func getAccessibilitySettings() async -> [String]
    func isTouchExplorationEnabled() async -> Bool
    func getAlarmAlertPath() async -> String
    func getTime12Or24() async -> String
    func getFontScale() async -> Float
    func getTextAutoReplace() async -> Bool
    func getTextAutoPunctuate() async -> Bool
    func getBootTime() async -> CLong
    func getCurrentBrightness() async -> Float
    func getSimInfoList() async -> [String: String]
    func getDefaultBrowser() async -> String
    func getAudioVolumeCurrent() async -> Float
    func getCarrierCountry() async -> String
    func isDebuggerEnabled() async -> Bool
    func checkBuildConfiguration() async -> String
    func getCPUType() async -> String
    func hasProximitySensor() async -> Bool
    func getLocalizedModel() async -> String
    func getSystemName() async -> String
    func getMacAddress() async -> String
    func getIPhoneBluetoothMacAddress() async -> String
    func getIPadBluetoothMacAddress() async -> String
    func getSerialNumber() async -> String
}
