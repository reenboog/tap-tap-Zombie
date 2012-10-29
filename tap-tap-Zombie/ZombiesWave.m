//
//  ZombiesWave.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "ZombiesWave.h"

#import "Zombie.h"

#import "Map.h"

#import "WaveCache.h"


static void shuffleArray(int *arr, int size)
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

@implementation ZombiesWave

@synthesize isPerfect;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<ZombiesWaveDelegate>) delegate_ 
                 weight: (int) weight 
         allowedObjects: (NSSet *) allowed
            awardFactor: (float) af
             movingTime: (float) mt 
           standingTime: (float) st
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        Map *map = delegate.map;
        
        BOOL isJumpersAllowed = [allowed containsObject: @"jumper"];
        BOOL isBadAllowed = [allowed containsObject: @"bad"];
        BOOL isShieldAllowed = [allowed containsObject: @"shield"];
        BOOL isBonusAllowed = [allowed containsObject: @"bonus"];
        BOOL isTimeBonusAllowed = [allowed containsObject: @"timeBonus"];
        
        BOOL isBadUsed = NO;
        BOOL isShieldUsed = NO;
        BOOL isBonusUsed = NO;
        BOOL isTimeBonusUsed = NO;
        
        Wave *wave = [[WaveCache sharedWaveCache] randomWaveWithWeight: weight 
                                                             maxTracks: map.nTracks 
                                                        jumpersAllowed: isJumpersAllowed];
        
        for(int i = 0; i < [wave.paths count]; i++)
        {
            NSArray *path = [wave.paths objectAtIndex: i];
            int index = [[path lastObject] intValue];
            Track track = map.tracks[index];
            NSArray *keyPoints = track.keyPoints;
            
            ZombieType zombieType = ZombieTypeNormal;
            
            if([path count] > 1)
            {
                NSMutableArray *kp = [[NSMutableArray alloc] init];
                float h = [[keyPoints objectAtIndex: 0] CGPointValue].y - [[keyPoints lastObject] CGPointValue].y;
                
                int N = [path count];
                for(int j = 0; j < N; j++)
                {
                    int pi = [[path objectAtIndex: j] intValue];
                    
                    int s = 0;
                    if(j > 0)
                    {
                        while(true)
                        {
                            float hh = [[map.tracks[pi].keyPoints objectAtIndex: s] CGPointValue].y;
                            
                            if(hh <= h*(N - j)/(float)N) break;
                            
                            s++;
                        }
                    }
                    
                    int e = s + 1;
                    if(j < N - 1)
                    {
                        while(true)
                        {
                            float hh = [[map.tracks[pi].keyPoints objectAtIndex: e] CGPointValue].y;
                            
                            if(hh < h*(N - j - 1)/(float)N) break;
                            
                            e++;
                        }
                    }
                    else
                    {
                        e = [map.tracks[pi].keyPoints count];
                    }
                    
                    for(int k = s; k < e; k++)
                    {
                        [kp addObject: [map.tracks[pi].keyPoints objectAtIndex: k]];
                    }
                }
                
                keyPoints = [NSArray arrayWithArray: kp];
                [kp release];
            }
            
            // set zombie type
            if(isBonusAllowed && !isBonusUsed && chance(20))
            {
                zombieType = ZombieTypeBonus;
                isBonusUsed = YES;
            }
            else if(isBadAllowed && !isBadUsed && chance(10))
            {
                zombieType = ZombieTypeBad;
                isBadUsed = YES;
            }
            else if(isShieldAllowed && !isShieldUsed && !delegate.isShieldModActivated && chance(30))
            {
                zombieType = ZombieTypeShield;
                isShieldUsed = YES;
            }
            else if(isTimeBonusAllowed && !isTimeBonusUsed && chance(30))
            {
                zombieType = ZombieTypeTimeBonus;
                isTimeBonusUsed = YES;
            }
            
            
            Zombie *zombie = [Zombie zombieWithDelegate: self type: zombieType awardFactor: af];
            zombie.tag = index;
            [self addChild: zombie];
            
            [zombie runWithKeyPoints: keyPoints movingTime: mt standingTime: st];
        }
        
        zombiesCounter = 0;
        for(Zombie *zombie in [self children])
        {
            if(zombie.type != ZombieTypeBad)
            {
                zombiesCounter++;
            }
        }
        
        capturedZombieCounter = 0;
        isPerfect = NO;
    }
    
    return self;
}


+ (id) zombieWaveWithDelegate: (id<ZombiesWaveDelegate>) delegate 
                       weight: (int) weight 
               allowedObjects: (NSSet *) allowed
                  awardFactor: (float) af
                   movingTime: (float) mt
                 standingTime: (float) st
{
    return [[[self alloc] initWithDelegate: delegate 
                                    weight: weight 
                            allowedObjects: allowed 
                               awardFactor: af
                                movingTime: mt 
                              standingTime: st] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark ZombieDelegate methods implementation
- (void) zombieFinished: (Zombie *) zombie
{
    [delegate zombieFinished: zombie];
}

- (void) zombieLeftFinish: (Zombie *) zombie
{
    [delegate zombieLeftFinish: zombie];
}

- (void) zombiePassed: (Zombie *) zombie
{
    [self removeChild: zombie cleanup: YES];
    
    if([[self children] count] < 1)
    { 
        if((capturedZombieCounter >= zombiesCounter) && (zombiesCounter > 0))
        {
            isPerfect = YES;
        }
        
        [delegate zombiesWavePassed: self];
    }
}

- (void) zombieCaptured: (Zombie *) zombie
{
    [delegate zombieCaptured: zombie];
    
    if(zombie.type != ZombieTypeBad)
    {
        capturedZombieCounter++;
    }
}

@end
