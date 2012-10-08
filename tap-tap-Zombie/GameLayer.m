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

- (BOOL) isShieldModActivated
{
    return traps.isShieldModActivated;
}

#pragma mark -

#pragma mark award

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
    
    [traps reset];
}

#pragma mark -

#pragma mark ZombiesWaveDelegate methods implementation
- (void) zombieFinished: (Zombie *) zombie
{
    if(traps.isShieldModActivated)
    {
        switch(zombie.type)
        { 
            case ZombieTypeNormal:
            case ZombieTypeJumper:
            case ZombieTypeShield:
            {
                [zombie capture];
            } break;
                
            default: break;
        }
        
        return;
    }
    
    switch(zombie.type)
    {
        case ZombieTypeBad:
        {
            [traps setTrapState: TrapStateRed atIndex: zombie.tag];
        } break;
            
        default:
        {
            [traps setTrapState: TrapStateGreen atIndex: zombie.tag];
        } break;
    }
}

- (void) zombieLeftFinish: (Zombie *) zombie
{
    switch(zombie.type)
    {
        case ZombieTypeBad:
        {
            [delegate increaseSuccess];
            [delegate giveAward: zombie.award];
        } break;
            
        case ZombieTypeNormal:
        case ZombieTypeJumper:
        {
            [delegate decreaseSuccess];
        } break;
            
        default: break;
    }
    
    [traps setTrapState: TrapStateNormal atIndex: zombie.tag];
}

- (void) zombiesWavePassed: (ZombiesWave *) zombiesWave
{
    [waves removeChild: zombiesWave cleanup: YES];
    [delegate updateGameState];
}

- (void) zombieCaptured: (Zombie *) zombie
{
    switch(zombie.type)
    {
        case ZombieTypeBad:
        {
            [delegate decreaseSuccess];
        } break;
            
        case ZombieTypeNormal:
        case ZombieTypeJumper:
        {
            [delegate increaseSuccess];
            [delegate giveAward: zombie.award];
        } break;
            
        case ZombieTypeShield:
        {
            [traps activateShieldModWithDuration: 5.0f];
        } break;
    }
    
    [traps setTrapState: TrapStateNormal atIndex: zombie.tag];
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
                
                return;
            }
        }
    }
    
    // if player tap empty trap
    [delegate decreaseSuccess];
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
