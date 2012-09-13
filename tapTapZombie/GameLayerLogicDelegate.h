//
//  GameLayerLogicDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameLogicDelegate;
@class Map;

@protocol GameLayerLogicDelegate <NSObject>

- (void) setDelegate: (id<GameLogicDelegate>) delegate;
- (Map *) map;

- (void) tick: (float) dt;

- (void) reset;
- (float) success;

@property (nonatomic, readonly) int perfectWaves;

// additional
- (float) currentMovingTime;
- (float) currentStandingTime;
- (float) maxMovingTime;
- (float) minMovingTime;
- (float) maxStandingTime;
- (float) minStandingTime;

@end
