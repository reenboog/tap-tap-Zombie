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
    float score;
    
    BOOL isGameFailed;
    BOOL isGameOver;
    
    BOOL isArcadeGame;
    
    Map *map;
    
    float successIncrementValue;
    float successDecrementValue;
    
    int superMode;
    int superModePerfectWavesCounter;
    int superModeFailedWavesCounter;
    float superModeTimer;
    
    int totalPerfectWavesCounter;
    int totalFailedWavesCounter;
    
    int longestPerfectCycleLength;
    int currentPerfectCycleLength;
    
    ccTime timer;
    
    int zombiesLeft;
}

@property (nonatomic, readonly) BOOL isGameFailed;
@property (nonatomic, readonly) float score;
@property (nonatomic, readonly) int totalPerfectWavesCounter;
@property (nonatomic, readonly) int totalFailedWavesCounter;
@property (nonatomic, readonly) int longestPerfectCycleLength;
@property (nonatomic, readonly) float timer;
@property (nonatomic, readonly) BOOL isArcadeGame;

- (id) initWithMap: (Map *) map;
+ (id) gameSceneWithMap: (Map *) map;

- (Map *) map;

@end
