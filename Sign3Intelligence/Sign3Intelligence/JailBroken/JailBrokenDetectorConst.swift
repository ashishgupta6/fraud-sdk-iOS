//
//  JailBrokenDetectorConst.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 02/12/24.
//

import Foundation

internal struct JailBrokenDetectorConst {
    
    internal static var suspiciousFilePath = [
        "/var/mobile/Library/Preferences/ABPattern", // A-Bypass
        "/usr/lib/ABDYLD.dylib", // A-Bypass,
        "/usr/lib/ABSubLoader.dylib", // A-Bypass
        "/usr/sbin/frida-server", // frida
        "/etc/apt/sources.list.d/electra.list", // electra
        "/etc/apt/sources.list.d/sileo.sources", // electra
        "/.bootstrapped_electra", // electra
        "/usr/lib/libjailbreak.dylib", // electra
        "/jb/lzma", // electra
        "/.cydia_no_stash", // unc0ver
        "/.installed_unc0ver", // unc0ver
        "/jb/offsets.plist", // unc0ver
        "/usr/share/jailbreak/injectme.plist", // unc0ver
        "/etc/apt/undecimus/undecimus.list", // unc0ver
        "/var/lib/dpkg/info/mobilesubstrate.md5sums", // unc0ver
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/jb/jailbreakd.plist", // unc0ver
        "/jb/amfid_payload.dylib", // unc0ver
        "/jb/libjailbreak.dylib", // unc0ver
        "/usr/libexec/cydia/firmware.sh",
        "/var/lib/cydia",
        "/etc/apt",
        "/private/var/lib/apt",
        "/private/var/Users/",
        "/var/log/apt",
        "/Applications/Cydia.app",
        "/private/var/stash",
        "/private/var/lib/apt/",
        "/private/var/lib/cydia",
        "/private/var/cache/apt/",
        "/private/var/log/syslog",
        "/private/var/tmp/cydia.log",
        "/Applications/Icy.app",
        "/Applications/MxTube.app",
        "/Applications/RockApp.app",
        "/Applications/blackra1n.app",
        "/Applications/SBSettings.app",
        "/Applications/FakeCarrier.app",
        "/Applications/WinterBoard.app",
        "/Applications/IntelliScreen.app",
        "/private/var/mobile/Library/SBSettings/Themes",
        "/Library/MobileSubstrate/CydiaSubstrate.dylib",
        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/Applications/Sileo.app",
        "/var/binpack",
        "/Library/PreferenceBundles/LibertyPref.bundle",
        "/Library/PreferenceBundles/ShadowPreferences.bundle",
        "/Library/PreferenceBundles/ABypassPrefs.bundle",
        "/Library/PreferenceBundles/FlyJBPrefs.bundle",
        "/Library/PreferenceBundles/Cephei.bundle",
        "/Library/PreferenceBundles/SubstitutePrefs.bundle",
        "/Library/PreferenceBundles/libhbangprefs.bundle",
        "/usr/lib/libhooker.dylib",
        "/usr/lib/libsubstitute.dylib",
        "/usr/lib/substrate",
        "/usr/lib/TweakInject",
        "/var/binpack/Applications/loader.app", // checkra1n
        "/Applications/FlyJB.app", // Fly JB X
        "/Applications/Zebra.app", // Zebra
        "/Library/BawAppie/ABypass", // ABypass
        "/Library/MobileSubstrate/DynamicLibraries/SSLKillSwitch2.plist", // SSL Killswitch
        "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.plist", // PreferenceLoader
        "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.dylib", // PreferenceLoader
        "/Library/MobileSubstrate/DynamicLibraries", // DynamicLibraries directory in general
        "/var/mobile/Library/Preferences/me.jjolano.shadow.plist"
    ]
    
    internal static var directory = [
        "/",
        "/root/",
        "/private/",
        "/jb/"
    ]
    
    internal static var symbolicPath = [
        "/var/lib/undecimus/apt", // unc0ver
        "/Applications",
        "/Library/Ringtones",
        "/Library/Wallpaper",
        "/usr/arm-apple-darwin9",
        "/usr/include",
        "/usr/libexec",
        "/usr/share"
    ]
    
    
    internal static var suspiciousLibraries = [
      "systemhook.dylib", // Dopamine - hide jailbreak detection https://github.com/opa334/Dopamine/blob/dc1a1a3486bb5d74b8f2ea6ada782acdc2f34d0a/Application/Dopamine/Jailbreak/DOEnvironmentManager.m#L498
      "SubstrateLoader.dylib",
      "SSLKillSwitch2.dylib",
      "SSLKillSwitch.dylib",
      "MobileSubstrate.dylib",
      "TweakInject.dylib",
      "CydiaSubstrate",
      "cynject",
      "CustomWidgetIcons",
      "PreferenceLoader",
      "RocketBootstrap",
      "WeeLoader",
      "/.file", // HideJB (2.1.1) changes full paths of the suspicious libraries to "/.file"
      "libhooker",
      "SubstrateInserter",
      "SubstrateBootstrap",
      "ABypass",
      "FlyJB",
      "Substitute",
      "Cephei",
      "Electra",
      "AppSyncUnified-FrontBoard.dylib",
      "Shadow",
      "FridaGadget",
      "frida",
      "libcycript"
    ]
    
    internal static let urlSchemes = [
        "undecimus://",
        "sileo://",
        "zbra://",
        "filza://"
    ]

    
}
