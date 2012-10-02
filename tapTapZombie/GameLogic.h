//
//  GameLogic.h
//  tapTapZombie
//
//  Created by Alexander on 10.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameLogicDelegate.h"
#import "GameLayerLogicDelegate.h"
#import "GameItemLogicDelegate.h"


@class Map;

@interface GameLogic : NSObject <GameLayerLogicDelegate, GameItemLogicDelegate>
{
    id<GameLogicDelegate> delegate;
    
    float timer;
    
    Map *map;
    
    float currentMovingTime;
    float currentStandingTime;
    
    float success;
    
    NSMutableArray *waves;
    int perfectWaves;
    
    TraceEndStatus *tracesEnds;
}

@property (nonatomic, assign) id<GameLogicDelegate> delegate;

@property (nonatomic, readonly) Map *map;
@property (nonatomic, readonly) float success;
@property (nonatomic, readonly) int perfectWaves;
@property (nonatomic, readonly) TraceEndStatus *tracesEnds;

- (id) initWithMap: (Map *) map;
+ (id) gameLogicWithMap: (Map *) map;

- (void) reset;

// additional
- (float) currentMovingTime;
- (float) currentStandingTime;
- (float) maxMovingTime;
- (float) minMovingTime;
- (float) maxStandingTime;
- (float) minStandingTime;

@end
