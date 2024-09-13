//
//  SimulatorChecker.h
//  Sign3Intelligence
//
//  Created by Ashish Gupta on 10/09/24.
//

#ifndef SimulatorChecker_h
#define SimulatorChecker_h

#import <Foundation/Foundation.h>

@interface SimulatorChecker : NSObject

- (BOOL)isSimulator;

@end

@interface JailBrokenChecker : NSObject

- (BOOL)isJailBroken;

@end

#endif /* SimulatorChecker_h */
