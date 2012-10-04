//
//  ZombiesWave.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ZombiesWaveDelegate.h"

#import "ZombieDelegate.h"


@interface ZombiesWave : CCLayer <ZombieDelegate>
{
    id<ZombiesWaveDelegate> delegate;
}

- (id) initWithDelegate: (id<ZombiesWaveDelegate>) delegate;
+ (id) zombieWaveWithDelegate: (id<ZombiesWaveDelegate>) delegate;

@end
