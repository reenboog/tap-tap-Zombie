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

#import "MainMenuLoadingScene.h"

#import "GamePausePopup.h"
#import "GameOverPopup.h"
#import "TutorialPopup.h"

#import "MapCache.h"

#import "AnimationLoader.h"

#import "Settings.h"

#import "Shop.h"


#define kTimeForArcadeGame 30.0f

@interface GameScene()
- (void) increaseSuperMode;
- (void) dropSuperMode;
- (void) reset;
@end


@implementation GameScene

@synthesize isGameFailed;
@synthesize score;
@synthesize totalPerfectWavesCounter;
@synthesize totalFailedWavesCounter;
@synthesize longestPerfectCycleLength;
@synthesize timer;
@synthesize isArcadeGame;

#pragma mark init and dealloc
- (id) initWithMap: (Map *) map_
{
    if(self = [super init])
    {
        // load resources
        [[CCTextureCache sharedTextureCache] addImage: @"zombies/zombies.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"zombies/zombies.plist"];
        [[CCTextureCache sharedTextureCache] addImage: @"levels/traps/0/gate.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"levels/traps/0/gate.plist"];
        [[CCTextureCache sharedTextureCache] addImage: @"levels/traps/1/gate.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"levels/traps/1/gate.plist"];
        [[CCTextureCache sharedTextureCache] addImage: @"levels/traps/2/gate.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"levels/traps/2/gate.plist"];
        [[CCTextureCache sharedTextureCache] addImage: @"abilities/abilities.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"abilities/abilities.plist"];
        
        [AnimationLoader loadAnimationsWithPlist: @"zombies/animations"];
        [AnimationLoader loadAnimationsWithPlist: @"levels/traps/animations"];
        
        [[CCTextureCache sharedTextureCache] addImage: @"shop/icons/shopIcons.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"shop/icons/shopIcons.plist"];
     
        // init
        map = [map_ retain];
        
        isArcadeGame = runGameInArcadeMode;

        gameLayer = [GameLayer gameLayerWithDelegate: self andMap: map];
        [self addChild: gameLayer];
        
        hudLayer = [HUDLayer hudLayerWithDelegate: self];
        [self addChild: hudLayer];
        
        zombiesLeft = ((map.difficulty + 1.0f) + 1.0f)*(25.0f + map.index);//((map.difficulty + 1.0f)/2.0f + 1.0f)*(25.0f + map.index);
        
//        NSLog(@">> %f", n);
        
        successIncrementValue = 100.0f/zombiesLeft;
        successDecrementValue = 3.0f + map.difficulty;
        
        [self reset];
        
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

#pragma mark -

#pragma mark reset
- (void) reset
{
    isGameOver = NO;
    success = 0;
    score = 0;
    isGameFailed = NO;
    superModePerfectWavesCounter = 0;
    superModeFailedWavesCounter = 0;
    superMode = -1;
    superModeTimer = 0;
    
    totalPerfectWavesCounter = 0;
    totalFailedWavesCounter = 0;
    
    longestPerfectCycleLength = 0;
    currentPerfectCycleLength = 0;
    
    timer = isArcadeGame ? kTimeForArcadeGame : 0;
}

#pragma mark -

#pragma mark onEnter
- (void) onEnter
{
    [super onEnter];
    
    gameStatus.isStarted = YES;
    gameStatus.isActive = YES;
    
    NSMutableArray *showedTutorials = [Settings sharedSettings].showedTutorials;
    NSMutableArray *tutorialPages = [NSMutableArray arrayWithCapacity: 10];
    
    if(![showedTutorials containsObject: kGhostsTutorial])
    {
        [showedTutorials addObject: kGhostsTutorial];
        [tutorialPages addObject: kGhostsTutorial];
    }
    
    if(![showedTutorials containsObject: kTrapTutorial])
    {
        [showedTutorials addObject: kTrapTutorial];
        [tutorialPages addObject: kTrapTutorial];
    }
    
    if(![showedTutorials containsObject: kProgressTutorial])
    {
        [showedTutorials addObject: kProgressTutorial];
        [tutorialPages addObject: kProgressTutorial];
    }
    
    if(map.index > 2)
    {
        if(![showedTutorials containsObject: kBombTutorial])
        {
            [showedTutorials addObject: kBombTutorial];
            [tutorialPages addObject: kBombTutorial];
        }
        
        if(![showedTutorials containsObject: kSuperModeTutorial])
        {
            [showedTutorials addObject: kSuperModeTutorial];
            [tutorialPages addObject: kSuperModeTutorial];
        }
    }
    
    if(map.index > 3)
    {
        if(![showedTutorials containsObject: kJumperTutorial])
        {
            [showedTutorials addObject: kJumperTutorial];
            [tutorialPages addObject: kJumperTutorial];
        }
    }
    
    if(map.index > 6)
    {
        if(![showedTutorials containsObject: kShieldTutorial])
        {
            [showedTutorials addObject: kShieldTutorial];
            [tutorialPages addObject: kShieldTutorial];
        }
    }
    
    if(map.index > 7)
    {
        if(![showedTutorials containsObject: kBonusTutorial])
        {
            [showedTutorials addObject: kBonusTutorial];
            [tutorialPages addObject: kBonusTutorial];
        }
        
        if(![showedTutorials containsObject: kShopTutorial])
        {
            [showedTutorials addObject: kShopTutorial];
            [tutorialPages addObject: kShopTutorial];
        }
    }
    
    if(isArcadeGame)
    {
        if(![showedTutorials containsObject: kArcadeTutorial])
        {
            [showedTutorials addObject: kArcadeTutorial];
            [tutorialPages addObject: kArcadeTutorial];
        }
        
        if(![showedTutorials containsObject: kTimeBonusTutorial])
        {
            [showedTutorials addObject: kTimeBonusTutorial];
            [tutorialPages addObject: kTimeBonusTutorial];
        }
    }
    
    [[Settings sharedSettings] save];
    
    if([tutorialPages count] > 0)
    {
        [self addChild: [TutorialPopup popupWithDelegate: self pages: tutorialPages] z: kPopupZOrder];
    }
}

#pragma mark -

- (void) gameOver
{
    isGameOver = YES;
    isGameFailed = success == kMinSuccess;
    if(!isGameFailed && !isArcadeGame)
    {
        [[MapCache sharedMapCache] mapInfoAtIndex: map.index].isPassed = true;
        [[MapCache sharedMapCache] saveMapsInfo];
    }
    
    if(!isArcadeGame && (score > [Settings sharedSettings].bestScore))
    {
        [Settings sharedSettings].bestScore = score;
        [[Settings sharedSettings] save];
    }
    else if(isArcadeGame && (score > [Settings sharedSettings].bestArcadeScore))
    {
        [Settings sharedSettings].bestArcadeScore = score;
        [[Settings sharedSettings] save];
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
    
    gameStatus.isActive = NO;
}

- (void) popupDidFinishClosing:(CCPopupLayer *)popup
{
    [gameLayer resumeSchedulerAndActionsWithChildren];
    [gameLayer enableWithChildren];
    
    [hudLayer resumeSchedulerAndActionsWithChildren];
    [hudLayer enableWithChildren];
    
    gameStatus.isActive = YES;
}

#pragma mark -

#pragma mark HUDLayerDelegate methods implementation
- (void) pause
{
    [GamePausePopup showOnRunningSceneWithDelegate: self];
}

- (void) bombAbility
{
    [gameLayer bombAbility];
}

- (void) shieldAbility
{
    [gameLayer shieldAbility];
}

- (void) randomAbility
{
    [gameLayer randomAbility];
}

- (void) timebBonusAbility
{
    if(!isArcadeGame) return;
    
    [gameLayer timebBonusAbility];
}

- (void) win
{
    success = 100500;
    timer = 0;
}

#pragma mark GamePausePopupDelegate and GameOverPopupDelegate methods implementation
- (void) exit
{
    // go to main menu
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [MainMenuLoadingScene scene]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

- (void) restart
{
    [self reset];
    [gameLayer reset];
    [hudLayer reset];
    
    if(!isArcadeGame)
    {
        [hudLayer setProgressScaleValue: success];
    }
    else
    {
        [hudLayer setTimerValue: timer];
    }
    
    [hudLayer setScoreValue: score];
}

- (void) resurrection
{
    int resurrectionNum = [[[Shop sharedShop] itemWithName: kResurrection] amount];
    
    if(resurrectionNum > 0)
    {
        isGameOver = NO;
        isGameFailed = NO;
        
        timer = isArcadeGame ? kTimeForArcadeGame/2 : timer;
        
        [[[Shop sharedShop] itemWithName: kResurrection] spend];
        
        success = -50;
        
        [hudLayer setProgressScaleValue: success];
    }
}

- (float) bestScore
{
    return isArcadeGame ? [Settings sharedSettings].bestArcadeScore : [Settings sharedSettings].bestScore;
}

- (int) zombiesLeft
{
    return  (int)((kMaxSuccess - success)/successIncrementValue);
}

- (Map *) map
{
    return map;
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
    if(isArcadeGame) return;
    
    success = success < kMinSuccess ? kMinSuccess : success > kMaxSuccess ? kMaxSuccess : success;
    
    [hudLayer setProgressScaleValue: success];
}

- (void) increaseSuccess
{
    if(isGameOver || isArcadeGame) return;
    
    success += successIncrementValue;
    [self checkSuccess];
}

- (void) decreaseSuccess
{
    if(isGameOver || isArcadeGame) return;
    
    success -= successDecrementValue;
    [self checkSuccess];
}

- (void) updateGameState
{
    if(!isArcadeGame)
    {
        if((success == kMinSuccess) || (success == kMaxSuccess))
        {
            [self gameOver];
        }
    }
    else
    {
        if(timer <= 0)
        {
            [self gameOver];
        }
    }
}

- (void) perfectWave
{
    currentPerfectCycleLength++;
    
    if(longestPerfectCycleLength < currentPerfectCycleLength)
    {
        longestPerfectCycleLength = currentPerfectCycleLength;
    }
    
    totalPerfectWavesCounter++;
    superModePerfectWavesCounter++;
    
    if(((superMode == -1) && (superModePerfectWavesCounter >= 30)) ||
       ((superMode == 0) && (superModePerfectWavesCounter >= 10)) ||
       ((superMode == 1) && (superModePerfectWavesCounter >= 10)))
    {
        [self increaseSuperMode];
    }
}

- (void) failedWave
{
    currentPerfectCycleLength = 0;
    
    totalFailedWavesCounter++;
    
    if(superMode < 0) return;
    
    superModeFailedWavesCounter++;
    
    if(superModeFailedWavesCounter > 2)
    {
        [self dropSuperMode];
    }
}

- (void) addTimeBonus: (float) timeBonus
{
    assert(isArcadeGame);
    
    timer += timeBonus;
}

#pragma mark -

#pragma mark super mode
- (void) increaseSuperMode
{
    if(superMode > 1) return;
    
    superMode++;
    superModePerfectWavesCounter = 0;
    superModeFailedWavesCounter = 0;
    
    [hudLayer updateSuperModeLabelWithValue: superMode];
    
    if(superMode == 0)
    {
        [hudLayer showSuperModeLabel];
        superModeTimer = 12.0f;
        
        if(isArcadeGame) [self addTimeBonus: 5.0f];
    }
    else if(superMode == 1)
    {
        superModeTimer = 12.0f;
        
        if(isArcadeGame) [self addTimeBonus: 5.0f];
    }
    else if(superMode == 2)
    {
        superModeTimer = 15.0f;
        
        if(isArcadeGame) [self addTimeBonus: 10.0f];
    }
}

- (void) dropSuperMode
{
    superModePerfectWavesCounter = 0;
    superModeFailedWavesCounter = 0;
    superMode = -1;
    
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
    
    if(gameStatus.isActive)
    {
        timer += isArcadeGame ? -dt : dt;
    }
    
    if(isArcadeGame)
    {
        timer = timer < 0 ? 0 : timer;
        
        [hudLayer setTimerValue: timer];
    }
}

@end
