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

#import "Shop.h"


@implementation GameLayer

@synthesize map;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GameLayerDelegate>) delegate_ andMap: (Map *) map_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        map = [map_ retain];
        
        if(map.index < 2)
        {
            background = [Background0 backgroundWithNumberOfTracks: map.nTracks];
        }
        else if(map.index < 4)
        {
            background = [Background1 backgroundWithNumberOfTracks: map.nTracks];
        }
        else if(map.index < 14)
        {
            background = [Background2 backgroundWithNumberOfTracks: map.nTracks];
        }
        else if(map.index < 19)
        {
            background = [Background3 backgroundWithNumberOfTracks: map.nTracks];
        }
        else
        {
            background = [Background4 backgroundWithNumberOfTracks: map.nTracks];
        }
        [self addChild: background];
        
        float mi = map.index;
        float md = map.difficulty;
        
        if(runGameInArcadeMode)
        {
            mi = 23;
            md = 2;
        }
        
        timeBetweenWaves = 1.0f - (mi)/200.0f - (md)/15.0f;
        movingTime = 1.0f - (mi)/200.0f - (md)/15.0f;
        standingTime = 0.5f - ((mi)/200.0f - (md + 1.0f)/20.0f)/3.5f;
        
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

#pragma mark on enter
- (void) onEnter
{
    [super onEnter];
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
    
    [traps reset];
    
    waveWeight = 1;
    wavesCounter = 1;
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
            case ZombieTypeShield:
            case ZombieTypeBonus:
            case ZombieTypeTimeBonus:
            {
                [zombie capture];
//                [traps activateTrapAtIndex: zombie.tag];
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
        {
            [delegate decreaseSuccess];
        } break;
            
        default: break;
    }
    
    [traps setTrapState: TrapStateNormal atIndex: zombie.tag];
}

- (void) zombiesWavePassed: (ZombiesWave *) zombiesWave
{
    if(zombiesWave.isPerfect)
    {
        [delegate perfectWave];
    }
    else
    {
        [delegate failedWave];
    }
    
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
        {
            [delegate increaseSuccess];
            [delegate giveAward: zombie.award];
        } break;
            
        case ZombieTypeBonus:
        {
            [delegate giveAward: zombie.award];
        } break;
            
        case ZombieTypeTimeBonus:
        {
            [delegate addTimeBonus: zombie.award];
        } break;
            
        case ZombieTypeShield:
        {
            [traps activateShieldModWithDuration: 5.0f];
            
            for(int index = 0; index < map.nTracks; index++)
            {
                for(ZombiesWave *wave in [waves children])
                {
                    for(Zombie *zombie in [wave children])
                    {
                        if(zombie.onFinish && (zombie.tag == index) && (zombie.type != ZombieTypeBad))
                        {
                            [zombie capture];
                            [traps activateTrapAtIndex: index];
                        }
                    }
                }
            }
        } break;
    }
    
    [traps setTrapState: TrapStateNormal atIndex: zombie.tag];
}

#pragma mark -

#pragma mark TrapsLayer methods implementation
- (void) activatedTrapAtIndex: (int) index
{
    if(traps.isShieldModActivated) return;
    
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

- (NSSet *) getAllowedObjects
{
    NSMutableSet *a = [[NSMutableSet alloc] initWithCapacity: 5];
    
    if(map.index > 2)
    {
        [a addObject: @"bad"];
    }
    
    if(map.index > 3)
    {
        [a addObject: @"jumper"];
    }
    
    if(map.index > 6)
    {
        [a addObject: @"shield"];
    }
    
    if(map.index > 7)
    {
        [a addObject: @"bonus"];
    }
    
    if(delegate.isArcadeGame)
    {
        [a addObject: @"timeBonus"];
    }
    
    NSSet *allowedObjects = [NSSet setWithSet: a];
    [a release];
    
    return allowedObjects;
}

- (float) getAwardFactor
{
    return 1.0f + ((float)map.index)/100.0f + ((float)map.difficulty)/4.0f;
}

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
    
    ZombiesWave *zombiesWave = [ZombiesWave zombieWaveWithDelegate: self 
                                                            weight: waveWeight 
                                                    allowedObjects: [self getAllowedObjects]
                                                       awardFactor: [self getAwardFactor]
                                                        movingTime: movingTime
                                                      standingTime: standingTime];
    [waves addChild: zombiesWave z: t];
    
    wavesCounter++;
}

#pragma mark update
- (void) updateDifficulty
{
    static int nextUpdate = 5; 
    
    if(wavesCounter%nextUpdate == 0)
    {
        if(waveWeight == map.nTracks)
        {
            waveWeight--;
        }
        else if(waveWeight == 0)
        {
            waveWeight++;
        }
        else
        {
            if(arc4random()%2)
            {
                waveWeight++;
            }
            else if(arc4random()%2)
            {
                waveWeight += 2;
            }
            else if(arc4random()%3 == 0)
            {
                waveWeight--;
            }
            else if(arc4random()%6 == 0)
            {
                waveWeight -= 2;
            }
            else
            {
                waveWeight++;
            }
        }
        
        waveWeight = waveWeight < 1 ? 1 : waveWeight > map.nTracks ? map.nTracks : waveWeight;
        
        nextUpdate = arc4random()%2 ? 5 : 10;
        if(waveWeight == map.nTracks)
        {
            nextUpdate = 3;
        }
    }
}

- (void) update: (ccTime) dt
{
    timer -= dt;
    
    if(timer < 0)
    {
        timer = timeBetweenWaves;
        
        [self addNewZombiesWave];
        
        [self updateDifficulty];
    }
}

#pragma mark -

#pragma mark abilities
- (void) bomb
{
    for(ZombiesWave *z in [waves children])
    {
        [z destroy];
    }
}

- (void) timebBonus
{
    [delegate addTimeBonus: 10.0f];
}

- (void) shield
{
    [traps activateShieldModWithDuration: 5.0f];
    
    for(int index = 0; index < map.nTracks; index++)
    {
        for(ZombiesWave *wave in [waves children])
        {
            for(Zombie *zombie in [wave children])
            {
                if(zombie.onFinish && (zombie.tag == index) && (zombie.type != ZombieTypeBad))
                {
                    [zombie capture];
                    [traps activateTrapAtIndex: index];
                }
            }
        }
    }
}

- (void) bombAbility
{
    ShopItem *it = [[Shop sharedShop] itemWithName: kSuperblast];
    if([it amount] < 1) return;
    
    [it spend];
    
    [self bomb];
}

- (void) shieldAbility
{
    if(traps.isShieldModActivated) return;
    
    ShopItem *it = [[Shop sharedShop] itemWithName: kShield];
    if([it amount] < 1) return;
    
    [it spend];
    
    [self shield];
}

- (void) randomAbility
{
    ShopItem *it = [[Shop sharedShop] itemWithName: kGreatLottery];
    if([it amount] < 1) return;
    
    [it spend];
    
    if(delegate.isArcadeGame)
    {
        if(arc4random()%2)
        {
            [self timebBonus];
        }
        else if(arc4random()%3 > 0)
        {
            [self bomb];
        }
        else if(!traps.isShieldModActivated)
        {
            [self shield];
        }
        else
        {
            if(arc4random()%2)
            {
                [self bomb];
            }
            else
            {
                [self timebBonus];
            }
        }
    }
    else
    {
        if(arc4random()%3 && !traps.isShieldModActivated)
        {
            [self shield];
        }
        else
        {
            [self bomb];
        }
    }
}

- (void) timebBonusAbility
{
    if(!delegate.isArcadeGame) return;
    
    ShopItem *it = [[Shop sharedShop] itemWithName: kTimeCheater];
    if([it amount] < 1) return;
    
    [it spend];
    
    [self timebBonus];
}

#pragma mark -

@end
