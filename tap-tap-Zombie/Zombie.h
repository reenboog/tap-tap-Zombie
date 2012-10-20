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
    ZombieTypeBonus,
    ZombieTypeTimeBonus,
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
    BOOL isCaptured;
    
    float award;
    
    ZombieType type;
    
    int skinIndex;
}

@property (nonatomic, readonly) BOOL onFinish;
@property (nonatomic, readonly) float award;
@property (nonatomic, readonly) ZombieType type;

- (id) initWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type awardFactor: (float) af;
+ (id) zombieWithDelegate: (id<ZombieDelegate>) delegate type: (ZombieType) type awardFactor: (float) af;

- (void) runWithKeyPoints: (NSArray *) keyPoints movingTime: (ccTime) mt standingTime: (ccTime) st;

- (void) capture;

@end
