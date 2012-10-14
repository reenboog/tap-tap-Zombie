//
//  WaveCache.h
//  tap-tap-Zombie
//
//  Created by Alexander on 12.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Wave.h"


@interface WaveCache : NSObject
{
    NSArray *waves;
}

+ (WaveCache *) sharedWaveCache;

- (Wave *) randomWaveWithWeight: (int) w maxTracks: (int) mt jumpersAllowed: (BOOL) ja;

@end
