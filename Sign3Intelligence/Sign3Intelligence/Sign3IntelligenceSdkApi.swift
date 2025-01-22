//
//  Sign3IntelligenceSdkApi.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

internal protocol Sign3IntelligenceSdkApi{
    func isVpnDetected() async -> Bool
    func isSimulatorDetected() async -> Bool
    func isJailBrokenDetected() async -> Bool
    func isMockLocation() async -> Bool
    func isAppTampered() async -> Bool
    func isProxyDetected() async -> Bool
    func isHookingDetected() async -> Bool
    func isScreenBeingMirrored() async -> Bool
    func isCloned() async -> Bool

}
