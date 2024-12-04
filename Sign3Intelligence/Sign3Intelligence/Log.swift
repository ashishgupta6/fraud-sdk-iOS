//
//  Log.swift
//  FraudSDK-iOS
//
//  Created by Sreyans Bohara on 03/12/24.
//


import Foundation
import os

struct Log {
    private static let subsystem = "com.yourapp"

    private enum Color: String {
        case red = "\u{001B}[31m"
        case yellow = "\u{001B}[33m"
        case white = "\u{001B}[37m"
        case reset = "\u{001B}[0m"
    }

    static func d(_ tag: String, _ message: String) {
        log(tag, message, color: .yellow, type: "DEBUG")
    }

    static func e(_ tag: String, _ message: String) {
        log(tag, message, color: .red, type: "ERROR")
    }

    static func i(_ tag: String, _ message: String) {
        log(tag, message, color: .white, type: "INFO")
    }

    private static func log(_ tag: String, _ message: String, color: Color, type: String) {
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: subsystem, category: tag)
            switch type {
            case "DEBUG":
                logger.debug("🟡 \(message, privacy: .public) 🟡")
            case "ERROR":
                logger.error("🔴 \(message, privacy: .public) 🔴")
            case "INFO":
                logger.info("⚪️ \(message, privacy: .public) ⚪️")
            default:
                break
            }
        } else {
            // Add color for iOS 12/13 console logs
            print("\(color.rawValue)[\(type)] [\(tag)]: \(message)\(Color.reset.rawValue)")
        }
    }
}