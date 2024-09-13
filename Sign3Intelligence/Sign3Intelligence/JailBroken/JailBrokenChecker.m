//
//  JailBrokenDetector.m
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 12/09/24.
//

#import <Foundation/Foundation.h>
#import "Sign3PrivateHeader.h"
#import <sys/stat.h>


@implementation JailBrokenChecker

- (BOOL)isJailBroken {
    NSArray *jailBreakFileList = @[
           @"/Applications/Cydia.app",
           @"/Applications/Sileo.app",
           @"/Applications/blackra1n.app",
           @"/Applications/jailbreaks.app",
           @"/Applications/unc0ver.app",
           @"/Applications/Zebra.app",
           @"/private/var/lib/apt/",
           @"/User/Applications/",
           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
           @"/bin/bash",
           @"/usr/sbin/sshd",
           @"/etc/apt",
           @"/var/jb",
           @"/etc/apt/sources.list.d",
           @"/etc/clutch.conf",
           @"/etc/clutch_cracked.plist",
           @"/etc/ssh/sshd_config",
           @"/Library/LaunchDaemons/com.openssh.sshd.plist",
           @"/Library/LaunchDaemons/com.rpetrich.rocketbootstrapd.plist",
           @"/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
           @"/Library/LaunchDaemons/com.tigisoftware.filza.helper.plist",
           @"/Library/LaunchDaemons/dhpdaemon.plist",
           @"/private/etc/apt",
           @"/private/etc/apt/preferences.d/checkra1n",
           @"/private/etc/apt/preferences.d/cydia",
           @"/private/etc/dpkg/origins/debian",
           @"/private/etc/ssh/sshd_config",
           @"/private/var/binpack/Applications/loader.app",
           @"/private/var/db/stash",
           @"/private/var/lib/cydia",
           @"/private/var/mobileLibrary/SBSettingsThemes",
           @"/private/var/tmp/cydia.log",
           @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
           @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
           @"/usr/bin/cycript",
           @"/usr/bin/DHPDaemon",
           @"/usr/bin/ssh"
       ];
       for (NSString *filePath in jailBreakFileList) {
           if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
               return YES;
           }
       }
       char *env = getenv("DYLD_INSERT_LIBRARIES");
       if (env != NULL) {
           return YES;
       }
       if (!access("/Library/MobileSubstrate/DynamicLibraries/",R_OK)) {
           return YES;
       }
       //symlink verification check
       NSArray *symlinkList = @[
           @"/Applications",
           @"/var/stash/Library/Ringtones",
           @"/var/stash/Library/Wallpaper",
           @"/var/stash/usr/include",
           @"/var/stash/usr/libexec",
           @"/var/stash/usr/share",
           @"/var/stash/usr/arm-apple-darwin9",
           @"/bin/bash"
       ];
       for (NSString *symlinkPath in symlinkList) {
           struct stat sym;
           int f = lstat(symlinkPath.UTF8String, &sym);
           if (f == 0 && (sym.st_mode & S_IFLNK)) {
               return YES;
           }
       }
       return NO;
}
@end
