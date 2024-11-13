//
//  DeviceSignalsApiImpl.m
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 19/09/24.
//

#import <Foundation/Foundation.h>
#import "Sign3PrivateHeader.h"


@implementation DeviceSignalsApiImplObjC

- (NSString *)getMacAddress {
    return [self getMacAddressForInterface:@"en0" adjustLastByte:0];
}

- (NSString *)getIPhoneBluetoothMacAddress {
    return [self getMacAddressForInterface:@"en0" adjustLastByte:-1];
}

- (NSString *)getIPadBluetoothMacAddress {
    return [self getMacAddressForInterface:@"en0" adjustLastByte:1];
}

// Helper method to retrieve the address
- (NSString *)getMacAddressForInterface:(NSString *)interfaceName adjustLastByte:(int)adjustment {
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct sockaddr_dl *dlAddr;
    const uint8_t *base;
    NSString *macAddress = nil;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER)
                && (strcmp(cursor->ifa_name, [interfaceName UTF8String]) == 0)) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const uint8_t *) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                
                if (dlAddr->sdl_alen == 6) {
                    // Adjust the last byte if needed
                    uint8_t lastByte = base[5] + adjustment;
                    macAddress = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", base[0], base[1], base[2], base[3], base[4], lastByte];
                } else {
                    macAddress = @"ERROR - len is not 6";
                }
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    } else {
        macAddress = @"ERROR - getifaddrs failed";
    }
    
    return macAddress;
}

@end

