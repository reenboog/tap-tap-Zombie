//
//  Game.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

#import "cocos2d.h"

#import "GameLayer.h"
#import "HUD.h"

#import "MainMenuLayer.h"

#import "GameConfig.h"


@implementation Game

@synthesize isActive;
@synthesize difficulty;

@synthesize nWays;
@synthesize startPoints;
@synthesize endPoints;

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

#pragma mark reset
- (void) reset
{
    isActive = NO;
    
    [gameLayer release];
    gameLayer = nil;
    
    timer = 0;
    
    difficulty = 0;
    
    if(startPoints) free(startPoints);
    if(endPoints) free(endPoints);
}

#pragma mark -

#pragma mark set difficulty
- (void) setDifficulty: (int) difficulty_
{
    difficulty_ = difficulty_ < 0 ? 0 : difficulty_ > kGameMaxDifficulty ? kGameMaxDifficulty : difficulty_;
    
    difficulty = difficulty_;
    
    nWays = difficulty < kGameMaxDifficulty ? difficulty + 3 : 5;
}

#pragma mark -

#pragma mark game
- (void) startGame
{
    startPoints = malloc(nWays*sizeof(CGPoint));
    endPoints = malloc(nWays*sizeof(CGPoint));
    
    float sy = kScreenHeight + 24.0f;
    float ey = 48.0f;
    
    for(int i = 0; i < nWays; i++)
    {
        float sx = (kScreenWidth - 48.0f*nWays)/2 + i*48.0f + 24.0f;
        float ex = (kScreenWidth - 72.0f*nWays)/2 + i*72.0f + 36.0f;
        
        startPoints[i] = ccp(sx, sy);
        endPoints[i] = ccp(ex, ey);
    }
    
    CCScene *gameScene = [CCScene node];
    
    gameLayer = [[GameLayer alloc] init];
    hud = [HUD hud];
    
    [gameScene addChild: gameLayer];
    [gameScene addChild: hud];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.3f
                                                                                  scene: gameScene
                                                                              withColor: ccc3(255, 255, 255)]];
}

- (void) exitGame
{
    [self reset];
    
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 0.3f
                                                                                  scene: [MainMenuLayer scene]
                                                                              withColor: ccc3(255, 255, 255)]];
}

- (void) resetGame
{
    timer = 0;
    
    [gameLayer reset];
}

- (void) pauseGame
{
    isActive = NO;
    
    [gameLayer pause];
}

- (void) resumeGame
{
    isActive = YES;
    
    [gameLayer resume];
}

void shuffleArray(int *arr, int size)
{
    if(size < 1) return;
    
    for(int i = 0; i < size - 1; i++)
    {
        int j = arc4random()%size;
        int t = arr[j];
        arr[j] = arr[i];
        arr[i] = t;
    }
}

- (void) newGameIteration
{
    int N = arc4random()%(nWays) + 1;
    
    int *si = malloc(nWays*sizeof(int));
    int *ei =  malloc(nWays*sizeof(int));
    
    for(int i = 0; i < nWays; i++)
    {
        si[i] = ei[i] = i;
    }
    
    shuffleArray(si, nWays);
    shuffleArray(ei, nWays);
    
    for(int i = 0; i < N; i++)
    {
        [gameLayer runGameItemWithStartPosition: startPoints[si[i]] endPosition: endPoints[ei[i]] time: 1.5f];
    }
    
    free(ei);
    free(si);
}

- (void) tick: (float) dt
{
    const static int timePerGameIteration = 1.8f;
    static BOOL flag = NO;
    
    if(timer < 0)
    {
        timer = timePerGameIteration;
        
        if(arc4random()%2 || flag)
        {
            [self newGameIteration];
            
            flag = NO;
        }
        else
        {
            flag = YES;
        }
    }
    
    timer -= dt;
}

@end