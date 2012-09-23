//
//  GameLayer.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GameLayer.h"
#import "GameItem.h"
#import "Game.h"

#import "LogicGameItemDelegate.h"


@implementation GameLayer

#pragma mark init and dealloc
- (id) initWithLogicDelegate: (id<GameLayerLogicDelegate, GameItemLogicDelegate>) logicDelegate_ hudDelegate: (id<GameLayerHUDDelegate>) hudDelegate_;
{
    if(self = [super init])
    {
        logicDelegate = [logicDelegate_ retain];
        [logicDelegate setDelegate: self];
        
        hudDelegate = [hudDelegate_ retain];
        [hudDelegate setDelegate: self];
        
        self.isTouchEnabled = YES;
        
        [self reset];
        
        [self scheduleUpdate];
    }
    
    return self;
}

+ (id) gameLayerWithLogicDelegate: (id<GameLayerLogicDelegate, GameItemLogicDelegate>) logicDelegate hudDelegate: (id<GameLayerHUDDelegate>) hudDelegate
{
    return [[[self alloc] initWithLogicDelegate: logicDelegate hudDelegate: hudDelegate] autorelease];
}

- (void) dealloc
{
    [logicDelegate release];
    [hudDelegate release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark onEnter/onExit
- (void) onEnter
{
    [super onEnter];
    
    [Game sharedGame].isStarted = YES;
    [Game sharedGame].isActive = YES;
}

- (void) onExit
{
    [super onExit];
    
    [Game sharedGame].isStarted = NO;
    [Game sharedGame].isActive = NO;
}

#pragma mark -

#pragma mark reset, pause and resume
- (void) reset
{
    [logicDelegate reset];
    
    [gameItems removeFromParentWithCleanup];
    
    gameItems = [CCLayer node];
    [self addChild: gameItems];
}

- (void) pause
{
    [self pauseSchedulerAndActionsWithChildren];
    [self disableWithChildren];
    
    [Game sharedGame].isActive = NO;
}

- (void) resume
{
    [self resumeSchedulerAndActionsWithChildren];
    [self enableWithChildren];
    
    [Game sharedGame].isActive = YES;
}

#pragma mark -

#pragma mark game items
- (id<LogicGameItemDelegate>) runGameItemWithTrack: (Track) track movingTime: (float) mt standingTime: (float) st
{            
    GameItem *item = [GameItem gameItemWithDelegate: logicDelegate];
    [item runWithKeyPoints: track.keyPoints movingTime: mt standingTime: st];
    [gameItems addChild: item];
    
    return item;
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
    [logicDelegate tick: dt];
    
    [hudDelegate updateMovingTime: [logicDelegate currentMovingTime] 
                              min: [logicDelegate minMovingTime] 
                              max: [logicDelegate maxMovingTime]];
    
    [hudDelegate updateStandingTime: [logicDelegate currentStandingTime] 
                                min: [logicDelegate minStandingTime] 
                                max: [logicDelegate maxStandingTime]];
    
    [hudDelegate setValueForProgressScale: [logicDelegate success]];
    
    [hudDelegate updatePerfectWays: logicDelegate.perfectWaves];
}

#pragma mark -

- (void) draw
{
    for(int i = 0; i < logicDelegate.map.nTracks; i++)
    {
        NSArray *keyPoints = logicDelegate.map.tracks[i].keyPoints;
        int n = [keyPoints count];
        
        CGPoint *vertices = malloc(sizeof(CGPoint)*n);
        for(int i = 0; i < n; i++)
        {
            vertices[i] = [[keyPoints objectAtIndex: i] CGPointValue];
        }
        
        ccDrawPoly(vertices, n, NO);
        
        free(vertices);
    }
}

@end