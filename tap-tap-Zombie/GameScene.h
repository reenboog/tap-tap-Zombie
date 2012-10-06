//
//  GameScene.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Map.h"

#import "GameLayerDelegate.h"
#import "HUDLayerDelegate.h"
#import "GamePausePopupDelegate.h"
#import "GameOverPopupDelegate.h"


#define kMinSuccess -100.0f
#define kMaxSuccess 100.0f

@class GameLayer;
@class HUDLayer;

@interface GameScene : CCScene <CCPopupLayerDelegate, GameLayerDelegate, 
                                HUDLayerDelegate, GamePausePopupDelegate, GameOverPopupDelegate>
{
    GameLayer *gameLayer;
    HUDLayer *hudLayer;
    
    float success;
    
    GameOverStatus gameOverStatus;
    
    BOOL isGameOver;
    
    Map *map;
}

@property (nonatomic, readonly) GameOverStatus gameOverStatus;

- (id) initWithMap: (Map *) map;
+ (id) gameSceneWithMap: (Map *) map;

@end
