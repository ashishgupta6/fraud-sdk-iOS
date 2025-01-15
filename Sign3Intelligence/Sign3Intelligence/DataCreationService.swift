//
//  DisplayAllSignals.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation

internal struct DataCreationService{
    
    private let deviceSignalsApi: DeviceSignalsApi = DeviceSignalsApiImpl()
    
    private lazy var sign3IntelliegnceSdkApiImpl: Sign3IntelligenceSdkApi = {
        return Sign3IntelligenceSdkApiImpl(deviceSignalsApi: deviceSignalsApi)
    }()
    
    internal func initColdStart() async {
        let base64TokenString = await deviceSignalsApi.generateDeviceToken()
        hitDeviceCheckApi(base64TokenString)
    }

    internal func hitDeviceCheckApi(_ base64TokenString: String) {
        Api.shared.queryDeviceCheck(deviceToken: base64TokenString) { resource in
            switch resource.status {
            case .success:
                Log.i("hitDeviceCheckApi", resource.data ?? "empty data")
            case .error:
                Log.e("hitDeviceCheckApi: ", "\(resource.message ?? "Unknown error")")
            case .loading: break
            }
        }
    }
    
    internal mutating func getDeviceParams() async -> DeviceParams {
        
        let curr = (Int(Date().timeIntervalSince1970 * 1000))
        Log.e("LLLLLLLL", "started \(curr)")
        let sign3IntelliegnceSdkApiImpl = self.sign3IntelliegnceSdkApiImpl
        let deviceSignalsApi = self.deviceSignalsApi
        
        async let isVpnEnabled = sign3IntelliegnceSdkApiImpl.isVpnDetected()
        async let isSimulatorDetected = sign3IntelliegnceSdkApiImpl.isSimulatorDetected()
        async let isJailBrokenDetected = sign3IntelliegnceSdkApiImpl.isJailBrokenDetected()
        async let locationSpoofer = sign3IntelliegnceSdkApiImpl.isMockLocation()
        async let appTampering = sign3IntelliegnceSdkApiImpl.isAppTampered()
        async let proxyDetector = sign3IntelliegnceSdkApiImpl.isProxyDetected()
        async let hookingDetector = sign3IntelliegnceSdkApiImpl.isHookingDetected()
        async let mirroredScreen = sign3IntelliegnceSdkApiImpl.isScreenBeingMirrored()
        async let appCloned = sign3IntelliegnceSdkApiImpl.isCloned()

        // Device signals
        async let deviceId = deviceSignalsApi.getiOSDeviceId()
        async let cloudId = deviceSignalsApi.getCloudId()
        async let appId = deviceSignalsApi.getApplicationId()
        async let idfa = deviceSignalsApi.getIDFA()
        async let batteryStatus = deviceSignalsApi.getBatteryStatus()
        async let batteryLevel = deviceSignalsApi.getBatteryLevel()
        async let cpuCount = deviceSignalsApi.getCpuCount()
        async let freeDiskSpace = deviceSignalsApi.getFreeDiskSpace()
        async let totalDiskSpace = deviceSignalsApi.getTotalDiskSpace()
        async let usedDiskSpace = deviceSignalsApi.getUsedDiskSpace()
        async let deviceModel = deviceSignalsApi.getDeviceModel()
        async let deviceName = deviceSignalsApi.getDeviceName()
        async let wifiIpAddress = deviceSignalsApi.getWifiIPAddress()
        async let displayScale = deviceSignalsApi.getDisplayScale()
        async let displayWidth = deviceSignalsApi.getDisplayWidth()
        async let displayHeight = deviceSignalsApi.getDisplayHeight()
        async let timeZone = deviceSignalsApi.getTimeZone()
        async let currentTime = deviceSignalsApi.getCurrentTime()
        async let currentLocal = deviceSignalsApi.getCurrentLocal()
        async let preferredLanguage = deviceSignalsApi.getPreferredLanguage()
        async let sandboxPath = deviceSignalsApi.getSandboxPath()
        async let mcc = deviceSignalsApi.getMobileCountryCode()
        async let ncc = deviceSignalsApi.getNetworkCountryCode()
        async let hostName = deviceSignalsApi.getHostName()
        async let isiOSAppOnMac = deviceSignalsApi.isiOSAppOnMac()
        async let orientation = deviceSignalsApi.getOrientation()
        async let carrierName = deviceSignalsApi.getCarrierName()
        async let networkType = deviceSignalsApi.getNetworkType()
        async let systemUptime = deviceSignalsApi.getSystemUptime()
        async let ramUsage = deviceSignalsApi.getRAMUsage()
        async let totalRamSize = deviceSignalsApi.getTotalRAMSize()
        async let kernelVersion = deviceSignalsApi.getKernelVersion()
        async let kernelOSVersion = deviceSignalsApi.getKernelOSVersion()
        async let kernelOSRelease = deviceSignalsApi.getKernelOSRelease()
        async let kernelOSType = deviceSignalsApi.getKernelOSType()
        async let iOSVersion = deviceSignalsApi.getiOSVersion()
        async let frameworkVersion = deviceSignalsApi.getFrameworkVersion()
        async let iOSAppVersion = deviceSignalsApi.getiOSAppVersion()
        async let appName = deviceSignalsApi.getAppName()
        async let appInstallTime = deviceSignalsApi.getAppInstallTime()
        async let appUpdateTime = deviceSignalsApi.getAppUpdateTime()
        async let appState = deviceSignalsApi.getAppState()
        async let appBuildNumber = deviceSignalsApi.getAppBuildNumber()
        async let frameworkBuildNumber = deviceSignalsApi.getFrameworkBuildNumber()
        async let location = deviceSignalsApi.getLocation()
        async let isTelephonySupported = deviceSignalsApi.isTelephonySupported()
        async let cameraList = deviceSignalsApi.getCameraList()
        async let abiType = deviceSignalsApi.getAbiType()
        async let ringtoneSource = deviceSignalsApi.getRingtoneSource()
        async let availableLocales = deviceSignalsApi.getAvailableLocales()
        async let securityProvidersData = deviceSignalsApi.getSecurityProvidersData()
        async let fingerprintSensorStatus = deviceSignalsApi.getFingerPrintSensorStatus()
        async let glesVersion = deviceSignalsApi.getGlesVersion()
        async let developmentSettingsEnabled = deviceSignalsApi.isDevelopmentSettingsEnabled()
        async let httpProxy = deviceSignalsApi.getHttpProxy()
        async let accessibilitySettings = deviceSignalsApi.getAccessibilitySettings()
        async let touchExplorationEnabled = deviceSignalsApi.isTouchExplorationEnabled()
        async let alarmAlertPath = deviceSignalsApi.getAlarmAlertPath()
        async let time12Or24 = deviceSignalsApi.getTime12Or24()
        async let fontScale = deviceSignalsApi.getFontScale()
        async let textAutoReplace = deviceSignalsApi.getTextAutoReplace()
        async let textAutoPunctuate = deviceSignalsApi.getTextAutoPunctuate()
        async let bootTime = deviceSignalsApi.getBootTime()
        async let currentBrightness = deviceSignalsApi.getCurrentBrightness()
        async let simInfoList = deviceSignalsApi.getSimInfoList()
        async let defaultBrowser = deviceSignalsApi.getDefaultBrowser()
        async let audioCurrentVolume = deviceSignalsApi.getAudioVolumeCurrent()
        async let carrierCountry = deviceSignalsApi.getCarrierCountry()
        async let debuggerEnabled = deviceSignalsApi.isDebuggerEnabled()
        async let checkBuildConfiguration = deviceSignalsApi.checkBuildConfiguration()
        async let cpuType = deviceSignalsApi.getCPUType()
        async let proximitySensor = deviceSignalsApi.hasProximitySensor()
        async let localizedModel = deviceSignalsApi.getLocalizedModel()
        async let systemName = deviceSignalsApi.getSystemName()
        async let macAddress = deviceSignalsApi.getMacAddress()
        async let iPhoneBluetoothMacAddress = deviceSignalsApi.getIPhoneBluetoothMacAddress()
        async let iPadBluetoothMacAddress = deviceSignalsApi.getIPadBluetoothMacAddress()
        async let lockdownMode = deviceSignalsApi.lockDownMode()
        async let wifiSSID = deviceSignalsApi.getWifiSSID()
        async let deviceReference = KeychainHelper.shared.retrieveDeviceFingerprint()

                
        let iOSDataRequest = await iOSDataRequest(
            iOSDeviceID: deviceId,
            applicationId: appId,
            advertisingID: idfa,
            cloudId: cloudId,
            simulator: isSimulatorDetected,
            jailBroken: isJailBrokenDetected,
            isVpn: isVpnEnabled,
            isGeoSpoofed: locationSpoofer,
            isAppTampering: appTampering,
            hooking: hookingDetector,
            proxy: proxyDetector,
            mirroredScreen: mirroredScreen,
            gpsLocation: GPSLocation(
                latitude: location.latitude,
                longitude: location.longitude,
                altitude: location.altitude
            ),
            cloned: appCloned
        )
        
        let iOSDeviceIDs = await iOSDeviceIDs(
            iOSDeviceId: deviceId,
            cloudId: cloudId,
            applicationId: appId,
            advertisingID: idfa
        )
        
        let deviceStateRawData = await DeviceStateRawData(
            displayWidth: displayWidth,
            displayHeight: displayHeight,
            displayScale: displayScale,
            timeZone: timeZone,
            currentTime: currentTime,
            currentLocal: currentLocal,
            preferredLanguage: preferredLanguage,
            sandboxPath: sandboxPath,
            mcc: mcc,
            ncc: ncc,
            hostName: hostName,
            isiOSAppOnMac: isiOSAppOnMac,
            orientation: orientation,
            carrierName: carrierName,
            networkType: networkType,
            systemUptime: systemUptime,
            ramUsage: ramUsage,
            totalRamSize: totalRamSize,
            telephonySupport: isTelephonySupported,
            ringtoneSource: ringtoneSource,
            availableLocals: availableLocales,
            fingerprintSensorStatus: fingerprintSensorStatus,
            developerOptionEnabled: developmentSettingsEnabled,
            httpProxy: httpProxy,
            accessibilitySettings: accessibilitySettings,
            touchExplorationEnabled: touchExplorationEnabled,
            alarmAlertPath: alarmAlertPath,
            time12Or24: time12Or24,
            fontScale: fontScale,
            textAutoReplace: textAutoReplace,
            textAutoPunctuate: textAutoPunctuate,
            bootTime: bootTime,
            currentBrightness: currentBrightness,
            defaultBrowser: defaultBrowser,
            audioVolumeCurrent: audioCurrentVolume,
            carrierCountry: carrierCountry,
            debuggerEnabled: debuggerEnabled,
            checkBuildConfiguration: checkBuildConfiguration,
            cpuType: cpuType,
            proximitySensor: proximitySensor,
            localizedModel: localizedModel,
            systemName: systemName,
            lockdownMode: lockdownMode,
            wifiSSID: wifiSSID,
            deviceReference: deviceReference
        )
        
        let hardwareFingerprintRawData = await HardwareFingerprintRawData(
            batteryState: batteryStatus,
            batteryLevel: batteryLevel,
            cpuCount: cpuCount,
            usedDiskSpace: usedDiskSpace,
            freeDiskSpace: freeDiskSpace,
            totalDiskSpace: totalDiskSpace,
            deviceModel: deviceModel,
            deviceName: deviceName,
            wifiIPAddress: wifiIpAddress,
            macAddress: macAddress,
            iPhonebluetoothMacAddress: iPhoneBluetoothMacAddress,
            iPadbluetoothMacAddress: iPadBluetoothMacAddress,
            cameraList: cameraList,
            abiType: abiType,
            glesVersion: glesVersion,
            simInfo: simInfoList
        )
        
        let installedAppsRawData = await InstalledAppsRawData(
            applicationName: appName,
            appInstallTime: appInstallTime,
            AppUpdateTime: appUpdateTime,
            appState: appState,
            frameworkVersion: frameworkVersion,
            frameworkBuildNumber: frameworkBuildNumber,
            appVersion: iOSAppVersion,
            appBuildNumber: appBuildNumber
        )
        
        let osBuildRawData = await OsBuildRawData(
            kernalVersion: kernelVersion,
            kernalOsVersion: kernelOSVersion,
            kernalOsRelease: kernelOSRelease,
            kernalOSType: kernelOSType,
            iOSVersion: iOSVersion,
            securityProvidersData: securityProvidersData
        )
        
        let deviceParams = await DeviceParams(
            iOSDataRequest: iOSDataRequest,
            deviceIdRawData: iOSDeviceRawData(
                iOSDeviceIDs: iOSDeviceIDs,
                deviceStateRawData: deviceStateRawData,
                hardwareFingerprintRawData: hardwareFingerprintRawData,
                installedAppsRawData: installedAppsRawData,
                osBuildRawData: osBuildRawData
            ),
            networkData: iOSNetworkData(
                networkLocation: NetworkLocation(
                    latitude: location.latitude,
                    longitude: location.longitude,
                    altitude: location.altitude
                )
            )
        )
        Log.e("LLLLLLLL", "ended \(Int(Date().timeIntervalSince1970 * 1000) - curr)")
        return deviceParams
        
    }
}
