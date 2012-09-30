//
//  Game.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"

#import "Game.h"

#import "MapCache.h"

#import "MainMenuLayer.h"
#import "SelectMapLayer.h"

#import "GameLogic.h"
#import "GameLayer.h"
#import "HUD.h"

#import "Backgrounds.h"


@implementation Game

@synthesize isStarted;
@synthesize isActive;

@synthesize mapIndex;
@synthesize difficulty;

@synthesize gameOverStatus;

static Game *sharedGame = nil;

#pragma mark singleton methods
+ (Game *) sharedGame
{
    if(!sharedGame)
    {
        sharedGame = [[Game alloc] init];
    }
    
    return sharedGame;
}

+ (void) releaseGame
{
    [sharedGame release];
}

#pragma mark -

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        [self reset];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark run scene
- (void) runScene: (CCScene *) scene
{
    if(![[CCDirector sharedDirector] runningScene])
    {
        [[CCDirector sharedDirector] runWithScene: scene];
        
        return;
    }
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.3f 
                                                                                  scene: scene
                                                                              withColor: ccc3(0, 0, 0)]];
}

- (void) runMainMenuScene
{
    CCScene *mainMenuScene = [MainMenuLayer scene];
    [self runScene: mainMenuScene];
    
    [self reset];
}

- (void) runSelectMapScene
{
    CCScene *selectMapScene = [SelectMapLayer scene];
    [self runScene: selectMapScene];
}

- (void) runGameScene
{
    CCScene *gameScene = [CCScene node];
    
    GameLogic *gameLogic = [GameLogic gameLogicWithMap: [[MapCache sharedMapCache] mapAtIndex: mapIndex withDifficulty: difficulty]];
    HUD *hud = [HUD hud];
    GameLayer *gameLayer = [GameLayer gameLayerWithLogicDelegate: gameLogic hudDelegate: hud];
    
    [gameScene addChild: gameLayer z: 0];
    [gameScene addChild: hud z: 1];
    
    int numberOfRoads = [[MapCache sharedMapCache] mapAtIndex: mapIndex withDifficulty: difficulty].nTracks;
    CCNode *background = [Level00Background backgroundWithNumberOfRoads: numberOfRoads];
    [gameLayer addChild: background z: -1];
    
    [self runScene: gameScene];
}

#pragma mark -

#pragma mark reset
- (void) reset
{
    isActive = NO;
    isStarted = NO;
    
    mapIndex = 0;
    difficulty = 0;
    
    [self dropGameOverStatus];
}

#pragma mark -

#pragma mark set difficulty
- (void) setDifficulty: (int) difficulty_
{
    difficulty = difficulty_ < 0 ? 0 : difficulty_ > kMaxGameDifficulty ? kMaxGameDifficulty : difficulty_;
}

#pragma mark -

#pragma mark game over status
- (void) setGameOverStatus: (GameOverStatus *) status
{
    assert(status);
    
    gameOverStatus = *status;
}

- (void) dropGameOverStatus
{
    [self setGameOverStatus: &((GameOverStatus){NO, 0, 0})];
}

@end