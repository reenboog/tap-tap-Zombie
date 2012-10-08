//
//  GameScene.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GameScene.h"

#import "GameLayer.h"
#import "HUDLayer.h"

#import "MainMenuLayer.h"

#import "GamePausePopup.h"
#import "GameOverPopup.h"

#import "MapCache.h"


@implementation GameScene

@synthesize isGameFailed;

#pragma mark init and dealloc
- (id) initWithMap: (Map *) map_
{
    if(self = [super init])
    {
        gameLayer = [GameLayer gameLayerWithDelegate: self andMap: map_];
        [self addChild: gameLayer];
        
        hudLayer = [HUDLayer hudLayerWithDelegate: self];
        [self addChild: hudLayer];
        
        map = [map_ retain];
        
        successIncrementValue = 2;
        successDecrementValue = 2;
    }
    
    return self;
}

+ (id) gameSceneWithMap: (Map *) map
{
    return [[[self alloc] initWithMap: map] autorelease];
}

- (void) dealloc
{
    [map release];
    
    [super dealloc];
}

- (void) reset
{
    isGameOver = NO;
    success = 0;
    score = 0;
    isGameFailed = NO;
}

#pragma mark -

- (void) gameOver
{
    isGameOver = YES;
    isGameFailed = success == kMinSuccess;
    if(!isGameFailed)
    {
        [[MapCache sharedMapCache] mapInfoAtIndex: map.index].isPassed = true;
        [[MapCache sharedMapCache] saveMapsInfo];
    }
    [GameOverPopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [gameLayer pauseSchedulerAndActionsWithChildren];
    [gameLayer disableWithChildren];
    
    [hudLayer pauseSchedulerAndActionsWithChildren];
    [hudLayer disableWithChildren];
}

- (void) popupDidFinishClosing:(CCPopupLayer *)popup
{
    [gameLayer resumeSchedulerAndActionsWithChildren];
    [gameLayer enableWithChildren];
    
    [hudLayer resumeSchedulerAndActionsWithChildren];
    [hudLayer enableWithChildren];
}

#pragma mark HUDLayerDelegate methods implementation
- (void) pause
{
    [GamePausePopup showOnRunningSceneWithDelegate: self];
}

#pragma mark GamePausePopupDelegate and GameOverPopupDelegate methods implementation
- (void) exit
{
    // go to main menu
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [MainMenuLayer scene]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

- (void) restart
{
    [self reset];
    [gameLayer reset];
    [hudLayer setProgressScaleValue: success];
}

#pragma mark GameLayerDelegate methods implementation
- (void) giveAward: (float) award_
{
    score += award_;
    
    [hudLayer setScoreValue: score];
}

- (void) checkSuccess
{
    success = success < kMinSuccess ? kMinSuccess : success > kMaxSuccess ? kMaxSuccess : success;
    
    [hudLayer setProgressScaleValue: success];
}

- (void) increaseSuccess
{
    if(isGameOver) return;
    
    success += successIncrementValue;
    [self checkSuccess];
}

- (void) decreaseSuccess
{
    if(isGameOver) return;
    
    success -= successDecrementValue;
    [self checkSuccess];
}

- (void) updateGameState
{
    if((success == kMinSuccess) || (success == kMaxSuccess))
    {
        [self gameOver];
    }
}

#pragma mark -

@end
