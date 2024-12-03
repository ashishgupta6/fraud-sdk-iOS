//
//  SimulatorChecker.m:  SimulatorChecker.m:  SimulatorChecker.m
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/09/24.
//

#import <Foundation/Foundation.h>
#import "Sign3PrivateHeader.h"


@implementation SimulatorChecker

- (BOOL)isSimulator {
    int simulator = 0;
#if TARGET_IPHONE_SIMULATOR
    simulator = 1;
#else
    simulator = 0;
#endif
    if (!simulator) {
        uint64_t dyld_simulator = 0;
        uint32_t dyld_count = _dyld_image_count();
        NSString* dyld_sim_str = @"usr/lib/dyld_sim";
        NSString* CoreSimulator_str = @"Library/Developer/CoreSimulator";
        char* cEmptyString = "";
        for (uint32_t i = 0; i < dyld_count; i++) {
            @autoreleasepool {
                if (i > 10000) break;
                NSString *dyld_image_name = [NSString stringWithCString:_dyld_get_image_name(i) ?: cEmptyString encoding:NSUTF8StringEncoding];
                if ([dyld_image_name hasSuffix:dyld_sim_str]) {
                    dyld_simulator |= 1;
                }
                if ([dyld_image_name containsString:CoreSimulator_str]) {
                    dyld_simulator |= 1 << 1;
                }
            }
        }
        simulator = (dyld_simulator ? 1 : 0);
    }
    return simulator;
}

@end
