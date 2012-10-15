//
//  GameLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameLayerDelegate.h"

#import "ZombiesWaveDelegate.h"
#import "TrapsLayerDelegate.h"

#import "TrapsLayer.h"


@class Map;

@interface GameLayer : CCLayer <ZombiesWaveDelegate, TrapsLayerDelegate>
{
    id<GameLayerDelegate> delegate;
    
    Map *map;
    
    CCLayer *background;
    CCLayer *waves;
    TrapsLayer *traps;
    
    ccTime timer;
    
//    float award;
    
    int waveWeight;
    
    float timeBetweenWaves;
    
    int wavesCounter;
    
    float movingTime;
    float standingTime;
}

@property (nonatomic, readonly) Map *map;
@property (nonatomic, readonly) BOOL isShieldModActivated;

- (id) initWithDelegate: (id<GameLayerDelegate>) delegate andMap: (Map *) map;
+ (id) gameLayerWithDelegate: (id<GameLayerDelegate>) delegate andMap: (Map *) map;

- (void) reset;

@end
