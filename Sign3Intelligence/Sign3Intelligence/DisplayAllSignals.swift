//
//  DisplayAllSignals.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 28/08/24.
//

import Foundation


struct DisplayAllSignals{
    
    static func displayAllSignals(deviceSignalsApiImpl: DeviceSignalsApiImpl){
        DispatchQueue.global().async {
            Task.detached{
                let deviceId = await deviceSignalsApiImpl.getiOSDeviceId()
                let cloudId = await deviceSignalsApiImpl.getCloudId()
                let appId = await deviceSignalsApiImpl.getApplicationId()
                let idfa = await deviceSignalsApiImpl.getIDFA()
                let idfv = await deviceSignalsApiImpl.getIDFV()
                let uuid = await deviceSignalsApiImpl.getUUID()
                let batteryStatus = await deviceSignalsApiImpl.getBatteryStatus()
                let batteryLavel = await deviceSignalsApiImpl.getBatteryLevel()
                let cpuCount = await deviceSignalsApiImpl.getCpuCount()
                let freeDiskSpace = await deviceSignalsApiImpl.getFreeDiskSpace()
                let totalDiskSpace = await deviceSignalsApiImpl.getTotalDiskSpace()
                let usedDiskSpace = await deviceSignalsApiImpl.getUsedDiskSpace()
                let deviceModel = await deviceSignalsApiImpl.getDeviceModel()
                let deviceName = await deviceSignalsApiImpl.getDeviceName()
                let wifiMacAddress = await deviceSignalsApiImpl.getWifiMacAddress()
                let displayScale = await deviceSignalsApiImpl.getDisplayScale()
                let displayWidth = await deviceSignalsApiImpl.getDisplayWidth()
                let displayHeight = await deviceSignalsApiImpl.getDisplayHeight()
                let timeZone = await deviceSignalsApiImpl.getTimeZone()
                let currentTime = await deviceSignalsApiImpl.getCurrentTime()
                let currentLocal = await deviceSignalsApiImpl.getCurrentLocal()
                let preferredLanguage = await deviceSignalsApiImpl.getPreferredLanguage()
                let sanboxPath = await deviceSignalsApiImpl.getSandboxPath()
                let mcc = await deviceSignalsApiImpl.getMobileCountryCode()
                let ncc = await deviceSignalsApiImpl.getNetworkCountryCode()
                let hostName = await deviceSignalsApiImpl.getHostName()
                let isiOSAppOnMac = await deviceSignalsApiImpl.isiOSAppOnMac()
                let orientation = await deviceSignalsApiImpl.getOrientation()
                let carrierName = await deviceSignalsApiImpl.getCarrierName()
                let networkType = await deviceSignalsApiImpl.getNetworkType()
                let systemUptime = await deviceSignalsApiImpl.getSystemUptime()
                let ramUses = await deviceSignalsApiImpl.getRAMUsage()
                let totalRamSize = await deviceSignalsApiImpl.getTotalRAMSize()
                let kernalVersion = await deviceSignalsApiImpl.getKernelVersion()
                let kernalOSVersion = await deviceSignalsApiImpl.getKernelOSVersion()
                let kernalOSRelase = await deviceSignalsApiImpl.getKernelOSRelease()
                let kernalOSType = await deviceSignalsApiImpl.getKernelOSType()
                let iOSVersion = await deviceSignalsApiImpl.getiOSVersion()
                let frameWorkVersion = await deviceSignalsApiImpl.getFrameworkVersion()
                let iOSAppVersion = await deviceSignalsApiImpl.getiOSAppVersion()
                let appName = await deviceSignalsApiImpl.getAppName()
                let appInstallTime = await deviceSignalsApiImpl.getAppInstallTime()
                let appUpdateTime = await deviceSignalsApiImpl.getAppUpdateTime()
                let appState = await deviceSignalsApiImpl.getAppState()
                let appBuildNumber = await deviceSignalsApiImpl.getAppBuildNumber()
                let frameworkBuildNumber = await deviceSignalsApiImpl.getFrameworkBuildNumber()

                Utils.checkThread()

                DispatchQueue.main.async {
                    Utils.showInfologs(tags: "Device ID", value: deviceId)
                    Utils.showInfologs(tags: "Cloud ID", value: cloudId)
                    Utils.showInfologs(tags: "Application ID", value: appId)
                    Utils.showInfologs(tags: "IDFA", value: idfa)
                    Utils.showInfologs(tags: "IDFV", value: idfv)
                    Utils.showInfologs(tags: "UUID", value: uuid)
                    Utils.showInfologs(tags: "Battery Status", value: batteryStatus)
                    Utils.showInfologs(tags: "Battery Level", value: String(batteryLavel))
                    Utils.showInfologs(tags: "Cpu Count", value: String(cpuCount))
                    Utils.showInfologs(tags: "Free Disk Space", value: freeDiskSpace)
                    Utils.showInfologs(tags: "Total Disk Space", value: totalDiskSpace)
                    Utils.showInfologs(tags: "Used Disk Space", value: usedDiskSpace)
                    Utils.showInfologs(tags: "Device Model", value: deviceModel)
                    Utils.showInfologs(tags: "Device Name", value: deviceName)
                    Utils.showInfologs(tags: "Wifi Mac Address", value: wifiMacAddress)
                    Utils.showInfologs(tags: "Display Scale", value: displayScale.description)
                    Utils.showInfologs(tags: "Display Width", value: displayWidth.description)
                    Utils.showInfologs(tags: "Display Height", value: displayHeight.description)
                    Utils.showInfologs(tags: "Time Zone", value: timeZone)
                    Utils.showInfologs(tags: "Current Time", value: currentTime)
                    Utils.showInfologs(tags: "Current Local", value: currentLocal)
                    Utils.showInfologs(tags: "Preferred Language", value: preferredLanguage)
                    Utils.showInfologs(tags: "Sandbox Path", value: sanboxPath)
                    Utils.showInfologs(tags: "Mobile Country Code", value: mcc)
                    Utils.showInfologs(tags: "Network Country Code", value: ncc)
                    Utils.showInfologs(tags: "Host Name", value: hostName)
                    Utils.showInfologs(tags: "Is iOS App On Mac", value: isiOSAppOnMac.description)
                    Utils.showInfologs(tags: "Orientation", value: orientation)
                    Utils.showInfologs(tags: "Carrier Name", value: carrierName)
                    Utils.showInfologs(tags: "Network Type", value: networkType)
                    Utils.showInfologs(tags: "System Uptime", value: systemUptime)
                    Utils.showInfologs(tags: "RAM Uses", value: ramUses)
                    Utils.showInfologs(tags: "Toatal RAM Size", value: totalRamSize)
                    Utils.showInfologs(tags: "Kernal Version", value: kernalVersion)
                    Utils.showInfologs(tags: "Kernal OS Version", value: kernalOSVersion)
                    Utils.showInfologs(tags: "Kernal OS Relase", value: kernalOSRelase)
                    Utils.showInfologs(tags: "Kernal OS Type", value: kernalOSType)
                    Utils.showInfologs(tags: "iOS Version", value: iOSVersion)
                    Utils.showInfologs(tags: "FrameWork Version", value: frameWorkVersion)
                    Utils.showInfologs(tags: "iOS APP Version", value: iOSAppVersion)
                    Utils.showInfologs(tags: "APP Name", value: appName)
                    Utils.showInfologs(tags: "APP Install Time", value: appInstallTime)
                    Utils.showInfologs(tags: "APP Update Time", value: appUpdateTime)
                    Utils.showInfologs(tags: "APP State", value: appState)
                    Utils.showInfologs(tags: "APP Build Number", value: appBuildNumber)
                    Utils.showInfologs(tags: "Framework Build Number", value: frameworkBuildNumber)

                }
            }
        }
    }
}
