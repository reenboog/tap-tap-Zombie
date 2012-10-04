//
//  Zombie.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "ZombieDelegate.h"


@interface Zombie : CCNode
{
    id<ZombieDelegate> delegate;
    
    CCSprite *sprite;
    
    NSArray *keyPoints;
    int nCurrentKeyPoint;
    
    float movingTime;
    float standingTime;
    
    BOOL isStarting;
    BOOL onFinish;
    
    float award;
}

@property (nonatomic, readonly) BOOL onFinish;
@property (nonatomic, readonly) float award;

- (id) initWithDelegate: (id<ZombieDelegate>) delegate;
+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate;

- (void) runWithKeyPoints: (NSArray *) keyPoints movingTime: (ccTime) mt standingTime: (ccTime) st;

- (void) capture;

@end
