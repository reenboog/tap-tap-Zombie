//
//  GameLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GameLayer.h"

#import "Map.h"

#import "Backgrounds.h"

#import "ZombiesWave.h"
#import "Zombie.h"


@implementation GameLayer

@synthesize map;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameLayerDelegate>) delegate_ andMap: (Map *) map_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        map = [map_ retain];
        
        background = [Background0 backgroundWithNumberOfTracks: map.nTracks];
        [self addChild: background];
        
//        finishLine = malloc(sizeof(float)*map.nTracks);
//        for(int i = 0; i < map.nTracks; i++) finishLine[i] = 0;
        
        [self reset];
        
        [self scheduleUpdate];
    }
    
    return self;
}

+ (id) gameLayerWithDelegate: (id<GameLayerDelegate>) delegate andMap: (Map *) map
{
    return [[[self alloc] initWithDelegate: delegate andMap: map] autorelease];
}

- (void) dealloc
{
    [map release];
    
//    free(finishLine);
    
    [super dealloc];
}

#pragma mark -

#pragma mark reset
- (void) reset
{
    [self removeChild: traps cleanup: YES];
    traps = [TrapsLayer trapsLayerWithDelegate: self];
    [self addChild: traps];
    
    [self removeChild: waves cleanup: YES];
    waves = [CCLayer node];
    [self addChild: waves];
}

#pragma mark -

#pragma mark ZombiesWaveDelegate methods implementation
- (void) zombieFinished: (Zombie *) zombie
{
    if(zombie.award < 0)
    {
        [traps setTrapState: TrapStateRed atIndex: zombie.tag];
    }
    else
    {
        [traps setTrapState: TrapStateGreen atIndex: zombie.tag];
    }
}

- (void) zombieLeftFinish: (Zombie *) zombie
{
    [delegate giveAward: -zombie.award];
    [traps setTrapState: TrapStateNormal atIndex: zombie.tag];
}

- (void) zombiesWavePassed: (ZombiesWave *) zombiesWave
{
    [waves removeChild: zombiesWave cleanup: YES];
}

#pragma mark -

#pragma mark TrapsLayer methods implementation
- (void) activatedTrapAtIndex: (int) index
{
    for(ZombiesWave *wave in [waves children])
    {
        for(Zombie *zombie in [wave children])
        {
            if(zombie.onFinish && (zombie.tag == index))
            {
                [zombie capture];
                
                [delegate giveAward: zombie.award];
            }
        }
    }
}

#pragma mark -

#pragma mark zombie's wave
- (void) addNewZombiesWave
{
    // why it doesn't work?
    // reorder waves
//    CCLOG(@"-");
//    for(CCNode *w in [waves children])
//    {
//        w.tag += 1;
//        [waves reorderChild: w z: w.tag];
//        CCLOG(@"%i", w.zOrder);
//    }
    
    static NSInteger t = 0;
    t--;
    
    ZombiesWave *zombiesWave = [ZombiesWave zombieWaveWithDelegate: self];
    [waves addChild: zombiesWave z: t];
}

#pragma mark update
- (void) update: (ccTime) dt
{
    const static float timeBetweenWaves = 1.0f;
    
    timer -= dt;
    
    if(timer < 0)
    {
        timer = timeBetweenWaves;
        
        [self addNewZombiesWave];
    }
}

#pragma mark -

@end
