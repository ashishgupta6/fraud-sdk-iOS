//
//  HookingDetectorConst.swift
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 26/11/24.
//

import Foundation

internal struct HookingDetectorConst {
    
    internal static let suspiciousLibraries: Set<String> = [
        // Frida-related libraries
        "FridaGadget",
        "frida",
        "frida-agent",
        "libfrida",
        
        // Cycript-related libraries
        "libcycript",
        "cynject",
        "cycript",
        
        // Needle-related libraries
        "needle",
        "libneedle",
        
        // Cydia Substrate and Substitute libraries
        "substrate",
        "Cydia",
        "SubstrateLoader",
        "libsubstitute",
        
        // Debugging and hooking tools
        "debugserver",
        "lldb",
        "libhooker",
        "libblack",
        "libobjc-trace",
        "libhook",
        
        // SSL pinning bypass tools
        "SSLKillSwitch",
        "SSLKillSwitch2",
        "SSLUnpinning",
        
        // Reverse engineering tools
        "objection",
        "dexspy",
        "HookZz",
        "fishhook",
        "unidbg",
        
        // Other generic tampering tools
        "CoreHook",
        "Flex",
        "FlexLoader",
        "inject",
        "injection",
        "cheatengine",
        "GameGuardian",
        "libinject",
        "Reveal",
        "RevealServer",
        "FridaServer",
        "Interpose"
    ]
    
    internal static let suspiciousPaths = [
        // Frida-related
        "/usr/sbin/frida-server",
        "/usr/local/bin/frida",
        "/usr/local/bin/frida-server",
        "/usr/lib/frida",
        "/usr/lib/frida-gadget.dylib",
        "/usr/bin/frida",
        
        // Cydia Substrate and Substitute
        "/usr/lib/substrate",
        "/usr/lib/substrate/SubstrateInjector.dylib",
        "/Library/MobileSubstrate",
        "/Library/MobileSubstrate/DynamicLibraries",
        
        // Jailbreak tools
        "/Applications/Cydia.app",
        "/Applications/Sileo.app",
        "/Applications/Zebra.app",
        "/Applications/Filza.app",
        "/bin/bash",
        "/bin/sh",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/private/var/lib/apt",
        "/usr/bin/ssh",
        
        // SSL Pinning Bypass
        "/Library/MobileSubstrate/DynamicLibraries/SSLKillSwitch.dylib",
        "/Library/MobileSubstrate/DynamicLibraries/SSLKillSwitch2.dylib",
        
        // Debugging tools
        "/usr/lib/libcycript.dylib",
        "/usr/local/bin/cycript",
        "/usr/bin/debugserver",
        "/private/var/db/stash",
        "/usr/bin/ssh",
        
        // Reverse engineering tools
        "/Applications/Flex.app",
        "/Applications/Reveal.app",
        "/Applications/Frida.app",
        "/Library/FridaGadget.dylib",
        "/usr/lib/libhooker.dylib",
        "/usr/lib/libblack.dylib",
        "/usr/lib/libobjc-trace.dylib",
        "/usr/lib/libinject.dylib",
        
        // Other generic tampering tools
        "/var/cache/apt",
        "/private/var/lib/cydia",
        "/usr/libexec/sftp-server",
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/usr/libexec/cydia/",
        "/private/etc/dpkg/origins/debian"
    ]
    
    internal static let ports = [
        27042, // default Frida
        4444, // default Needle
        22, // OpenSSH
        44 // checkra1n
    ]
}
