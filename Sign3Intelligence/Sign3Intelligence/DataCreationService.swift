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
    
    internal mutating func getDeviceParams() async -> DeviceParams{
        // Detectors
        let isVpnEnabled = await sign3IntelliegnceSdkApiImpl.isVpnDetected()
        let isSimulatorDetected = await sign3IntelliegnceSdkApiImpl.isSimulatorDetected()
        let isJainBrokenDetected = await sign3IntelliegnceSdkApiImpl.isJailBrokenDetected()
        let locationSpoffer = await sign3IntelliegnceSdkApiImpl.isMockLocation()
        let appTampering = await sign3IntelliegnceSdkApiImpl.isAppTampered()
        let proxyDetector = await sign3IntelliegnceSdkApiImpl.isProxyDetected()
        let hookingDetector = await sign3IntelliegnceSdkApiImpl.isHookingDetected()
        let mirroredScreen = await sign3IntelliegnceSdkApiImpl.isScreenBeingMirrored()
        
        
        // Signals
        let deviceId = await deviceSignalsApi.getiOSDeviceId()
        let cloudId = await deviceSignalsApi.getCloudId()
        let appId = await deviceSignalsApi.getApplicationId()
        let idfa = await deviceSignalsApi.getIDFA()
        let batteryStatus = await deviceSignalsApi.getBatteryStatus()
        let batteryLavel = await deviceSignalsApi.getBatteryLevel()
        let cpuCount = await deviceSignalsApi.getCpuCount()
        let freeDiskSpace = await deviceSignalsApi.getFreeDiskSpace()
        let totalDiskSpace = await deviceSignalsApi.getTotalDiskSpace()
        let usedDiskSpace = await deviceSignalsApi.getUsedDiskSpace()
        let deviceModel = await deviceSignalsApi.getDeviceModel()
        let deviceName = await deviceSignalsApi.getDeviceName()
        let wifiIpAddress = await deviceSignalsApi.getWifiIPAddress()
        let displayScale = await deviceSignalsApi.getDisplayScale()
        let displayWidth = await deviceSignalsApi.getDisplayWidth()
        let displayHeight = await deviceSignalsApi.getDisplayHeight()
        let timeZone = await deviceSignalsApi.getTimeZone()
        let currentTime = await deviceSignalsApi.getCurrentTime()
        let currentLocal = await deviceSignalsApi.getCurrentLocal()
        let preferredLanguage = await deviceSignalsApi.getPreferredLanguage()
        let sanboxPath = await deviceSignalsApi.getSandboxPath()
        let mcc = await deviceSignalsApi.getMobileCountryCode()
        let ncc = await deviceSignalsApi.getNetworkCountryCode()
        let hostName = await deviceSignalsApi.getHostName()
        let isiOSAppOnMac = await deviceSignalsApi.isiOSAppOnMac()
        let orientation = await deviceSignalsApi.getOrientation()
        let carrierName = await deviceSignalsApi.getCarrierName()
        let networkType = await deviceSignalsApi.getNetworkType()
        let systemUptime = await deviceSignalsApi.getSystemUptime()
        let ramUses = await deviceSignalsApi.getRAMUsage()
        let totalRamSize = await deviceSignalsApi.getTotalRAMSize()
        let kernalVersion = await deviceSignalsApi.getKernelVersion()
        let kernalOSVersion = await deviceSignalsApi.getKernelOSVersion()
        let kernalOSRelase = await deviceSignalsApi.getKernelOSRelease()
        let kernalOSType = await deviceSignalsApi.getKernelOSType()
        let iOSVersion = await deviceSignalsApi.getiOSVersion()
        let frameWorkVersion = await deviceSignalsApi.getFrameworkVersion()
        let iOSAppVersion = await deviceSignalsApi.getiOSAppVersion()
        let appName = await deviceSignalsApi.getAppName()
        let appInstallTime = await deviceSignalsApi.getAppInstallTime()
        let appUpdateTime = await deviceSignalsApi.getAppUpdateTime()
        let appState = await deviceSignalsApi.getAppState()
        let appBuildNumber = await deviceSignalsApi.getAppBuildNumber()
        let frameworkBuildNumber = await deviceSignalsApi.getFrameworkBuildNumber()
        let location = await deviceSignalsApi.getLocation()
        let isTelephonySupported = await deviceSignalsApi.isTelephonySupported()
        let cameraList = await deviceSignalsApi.getCameraList()
        let abiType = await deviceSignalsApi.getAbiType()
        let ringToneSource = await deviceSignalsApi.getRingtoneSource()
        let availableLocals = await deviceSignalsApi.getAvailableLocales()
        let securityProvidersData = await deviceSignalsApi.getSecurityProvidersData()
        let fingerPrintSensorStatus = await deviceSignalsApi.getFingerPrintSensorStatus()
        let glesVersion = await deviceSignalsApi.getGlesVersion()
        let developmentSettingsEnabled = await deviceSignalsApi.isDevelopmentSettingsEnabled()
        let httpProxy = await deviceSignalsApi.getHttpProxy()
        let accessibilitySettings = await deviceSignalsApi.getAccessibilitySettings()
        let touchExplorationEnabled = await deviceSignalsApi.isTouchExplorationEnabled()
        let alarmAlertPath = await deviceSignalsApi.getAlarmAlertPath()
        let time12Or24 = await deviceSignalsApi.getTime12Or24()
        let fontScale = await deviceSignalsApi.getFontScale()
        let textAutoReplace = await deviceSignalsApi.getTextAutoReplace()
        let textAutoPunctuate = await deviceSignalsApi.getTextAutoPunctuate()
        let bootTime = await deviceSignalsApi.getBootTime()
        let currentBrightness = await deviceSignalsApi.getCurrentBrightness()
        let simInfoList = await deviceSignalsApi.getSimInfoList()
        let defaultBrowser = await deviceSignalsApi.getDefaultBrowser()
        let audioCurrentVolume = await deviceSignalsApi.getAudioVolumeCurrent()
        let carrierCountry = await deviceSignalsApi.getCarrierCountry()
        let debuggerEnabled = await deviceSignalsApi.isDebuggerEnabled()
        let checkBuildConfiguration = await deviceSignalsApi.checkBuildConfiguration()
        let cpuType = await deviceSignalsApi.getCPUType()
        let proximitySensor = await deviceSignalsApi.hasProximitySensor()
        let localizedModel = await deviceSignalsApi.getLocalizedModel()
        let systemName = await deviceSignalsApi.getSystemName()
        let macAddress = await deviceSignalsApi.getMacAddress()
        let serialNumber = await deviceSignalsApi.getSerialNumber()
        let iPhoneBluetoothMacAddress = await deviceSignalsApi.getIPhoneBluetoothMacAddress()
        let iPadBluetoothMacAddress = await deviceSignalsApi.getIPadBluetoothMacAddress()
        
        let iOSDataRequest = iOSDataRequest(
            iOSDeviceID: deviceId,
            applicationId: appId,
            advertisingID: idfa,
            cloudId: cloudId,
            simulator: isSimulatorDetected,
            jailBroken: isJainBrokenDetected,
            isVpn: isVpnEnabled,
            isGeoSpoofed: locationSpoffer,
            isAppTampering: appTampering,
            hooking: hookingDetector,
            proxy: proxyDetector,
            mirroredScreen: mirroredScreen
        )
        
        let androidDeviceIDs = AndroidDeviceIDs(
            iOSDeviceId: deviceId,
            cloudId: cloudId,
            applicationId: appId,
            advertisingID: idfa
        )
        
        let deviceStateRawData = DeviceStateRawData(
            displayWidth: displayWidth,
            displayHeight: displayHeight,
            displayScale: displayScale,
            timeZone: timeZone,
            currentTime: currentTime,
            currentLocal: currentLocal,
            preferredLanguage: preferredLanguage,
            sandboxPath: sanboxPath,
            mcc: mcc,
            ncc: ncc,
            hostName: hostName,
            isiOSAppOnMac: isiOSAppOnMac,
            orientation: orientation,
            carrierName: carrierName,
            networkType: networkType,
            systemUptime: systemUptime,
            ramUsage: ramUses,
            totalRamSize: totalRamSize,
            telephonySupport: isTelephonySupported,
            ringtoneSource: ringToneSource,
            availableLocals: availableLocals,
            fingerprintSensorStatus: fingerPrintSensorStatus,
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
            serialNumber: serialNumber
        )
        
        let hardwareFingerprintRawData = HardwareFingerprintRawData(
            batteryState: batteryStatus,
            batteryLevel: batteryLavel,
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
        
        let installedAppsRawData = InstalledAppsRawData(
            applicationName: appName,
            appInstallTime: appInstallTime,
            AppUpdateTime: appUpdateTime,
            appState: appState,
            frameworkVersion: frameWorkVersion,
            frameworkBuildNumber: frameworkBuildNumber,
            appVersion: iOSAppVersion,
            appBuildNumber: appBuildNumber
        )
        
        let osBuildRawData = OsBuildRawData(
            kernalVersion: kernalVersion,
            kernalOsVersion: kernalOSVersion,
            kernalOsRelease: kernalOSRelase,
            kernalOSType: kernalOSType,
            iOSVersion: iOSVersion,
            securityProvidersData: securityProvidersData
        )
        
        let deviceParams = DeviceParams(
            iOSDataRequest: iOSDataRequest,
            deviceIdRawData: iOSDeviceRawData(
                androidDeviceIDs: androidDeviceIDs,
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
        
        return deviceParams
        
    }
}
