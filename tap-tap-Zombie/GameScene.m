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


@interface GameScene()
- (void) increaseSuperMode;
- (void) dropSuperMode;
@end


@implementation GameScene

@synthesize isGameFailed;
@synthesize score;

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
        
        float n = ((map.difficulty + 1.0f)/2.0f + 1.0f)*(25.0f + map.index);
        
//        NSLog(@">> %f", n);
        
        successIncrementValue = 100.0f/n;
        successDecrementValue = 1.0f + map.difficulty;
        
        [self scheduleUpdate];
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
    perfectWaves = 0;
    superMode = -1;
    superModeTimer = 0;
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
    float awardFactor = superMode == 0 ? 2.0f : superMode == 1 ? 3.0f : superMode == 2 ? 5.0f : 1.0f;
    awardFactor = award_ > 0 ? awardFactor : 1.0f;
    
    score += award_*awardFactor;
    
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

- (void) perfectWave
{
    perfectWaves++;
    
    if(((superMode == -1) && (perfectWaves >= 4)) || 
       ((superMode == 0) && (perfectWaves >= 6)) || 
       ((superMode == 1) && (perfectWaves >= 8)))
    {
        [self increaseSuperMode];
    }
}

- (void) failedWave
{
    if(superMode < 0) return;
    
    failedWaves++;
    
    if(failedWaves > 2)
    {
        [self dropSuperMode];
    }
}

#pragma mark -

#pragma mark super mode
- (void) increaseSuperMode
{
    if(superMode > 1) return;
    
    superMode++;
    perfectWaves = 0;
    failedWaves = 0;
    
    [hudLayer updateSuperModeLabelWithValue: superMode];
    
    if(superMode == 0)
    {
        [hudLayer showSuperModeLabel];
        superModeTimer = 10.0f;
    }
    else if(superMode == 1)
    {
        superModeTimer = 10.0f;
    }
    else if(superMode == 2)
    {
        superModeTimer = 15.0f;
    }
}

- (void) dropSuperMode
{
    perfectWaves = 0;
    superMode = -1;
    failedWaves = 0;
    
    [hudLayer hideSuperModeLabel];
}

#pragma mark -

#pragma mark update
- (void) update: (ccTime) dt
{
    superModeTimer -= dt;
    
    if((superModeTimer <= 0) && (superMode >= 0))
    {
        [self dropSuperMode];
    }
    
    superModeTimer = superModeTimer < 0 ? 0 : superModeTimer;
}

@end
