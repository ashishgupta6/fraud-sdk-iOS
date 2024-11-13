//
//  SimulatorChecker.h
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/09/24.
//

#ifndef SimulatorChecker_h
#define SimulatorChecker_h

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <netdb.h>
#include <net/if_dl.h>
#include <string.h>
#include <net/if_types.h>
#import <sys/stat.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/IOMessage.h>
#import <IOKit/IOKitKeys.h>

@interface SimulatorChecker : NSObject

- (BOOL)isSimulator;

@end

@interface JailBrokenChecker : NSObject

- (BOOL)isJailBroken;

@end

@interface DeviceSignalsApiImplObjC : NSObject

- (NSString *)getMacAddress;
- (NSString *)getIPhoneBluetoothMacAddress;
- (NSString *)getIPadBluetoothMacAddress;

@end

#endif /* SimulatorChecker_h */
