//
//  GameLayer.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "GameLogicDelegate.h"
#import "HUDDelegate.h"

#import "GameLayerLogicDelegate.h"
#import "GameLayerHUDDelegate.h"
#import "GameItemLogicDelegate.h"


@class Trap;

@interface GameLayer : CCLayer <GameLogicDelegate, HUDDelegate>
{
    id<GameLayerLogicDelegate, GameItemLogicDelegate> logicDelegate;
    id<GameLayerHUDDelegate> hudDelegate;
    
    CCLayer *gameItems;
    
    CCLayer *traps;
}

- (id) initWithLogicDelegate: (id<GameLayerLogicDelegate, GameItemLogicDelegate>) logicDelegate 
                 hudDelegate: (id<GameLayerHUDDelegate>) hudDelegate;

+ (id) gameLayerWithLogicDelegate: (id<GameLayerLogicDelegate, GameItemLogicDelegate>) logicDelegate 
                      hudDelegate: (id<GameLayerHUDDelegate>) hudDelegate;

- (void) reset;
- (void) pause;
- (void) resume;

@end
