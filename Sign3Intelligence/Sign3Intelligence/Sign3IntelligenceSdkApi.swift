//
//  Sign3IntelligenceSdkApi.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 09/09/24.
//

import Foundation

protocol Sign3IntelligenceSdkApi{
    func isVpnDetected() async -> Bool
    func isSimulatorDetected() async -> Bool
    func isJailBrokenDetected() async -> Bool
    func isMockLocation() async -> Bool
    func isAppTampered() async -> Bool
    func isProxyDetected() async -> Bool
}
