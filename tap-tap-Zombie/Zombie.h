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


typedef enum
{
    ZombieTypeNormal,
    ZombieTypeBad,
    ZombieTypeJumper,
    ZombieTypeShield
} ZombieType;


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
    
    ZombieType type;
}

@property (nonatomic, readonly) BOOL onFinish;
@property (nonatomic, readonly) float award;
@property (nonatomic, readonly) ZombieType type;

- (id) initWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type;
+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type;

- (void) runWithKeyPoints: (NSArray *) keyPoints movingTime: (ccTime) mt standingTime: (ccTime) st;

- (void) capture;

@end
