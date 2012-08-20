//
//  GameLayer.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "MainMenuLayer.h"

#import "GameConfig.h"

#import "Game.h"

#import "GameItem.h"


@implementation GameLayer

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        self.isTouchEnabled = YES;
        
        [self reset];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark reset, pause and resume
- (void) reset
{
    [gameItems removeFromParentWithCleanup];
    
    gameItems = [CCLayer node];
    [self addChild: gameItems];
}

- (void) pause
{
    [self pauseSchedulerAndActionsWithChildren];
    [self disableWithChildren];
}

- (void) resume
{
    [self resumeSchedulerAndActionsWithChildren];
    [self enableWithChildren];
}

#pragma mark -

#pragma mark game items
- (void) runGameItemWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t
{
    [gameItems addChild: [GameItem gameItemWithStartPosition: sp endPosition: ep time: t]];
}

#pragma mark -

#pragma mark touches
- (void) ccTouchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    for(UITouch *touch in touches)
    {
        for(GameItem *item in [gameItems children])
        {
            [item tap: touch];
        }
    }
}

#pragma mark -

#pragma mark update
- (void) update: (ccTime) dt
{
    [[Game sharedGame] tick: dt];
}

#pragma mark -

- (void) draw
{
    for(int i = 0; i < [Game sharedGame].nWays; i++)
    {
        CGPoint sp = [Game sharedGame].startPoints[i];
        
        for(int j = 0; j < [Game sharedGame].nWays; j++)
        {
            CGPoint ep = [Game sharedGame].endPoints[j];
            
            ccDrawCubicBezier(sp, 
                              ccp(sp.x, kScreenCenterY), 
                              ccp(ep.x, kScreenCenterY), 
                              ep, 
                              100);   
        }
    }
}

@end