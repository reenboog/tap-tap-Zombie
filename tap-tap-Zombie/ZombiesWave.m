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

#pragma mark init and dealloc
- (id) initWithDelegate: (id<ZombiesWaveDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        Map *map = delegate.map;
        
        int N = arc4random()%(map.nTracks) + 1;
        int *indices = malloc(map.nTracks*sizeof(int));
        for(int i = 0; i < map.nTracks; i++)
        {
            indices[i] = i;
        }
        
        shuffleArray(indices, map.nTracks);
        
        for(int i = 0; i < N; i++)
        {
            int index = indices[i];
            Track track = map.tracks[index];
            Zombie *zombie = [Zombie zombieWithDelegate: self];
            zombie.tag = index;
            [self addChild: zombie];
            
            [zombie runWithKeyPoints: track.keyPoints movingTime: 2.0f standingTime: 0.6f];
        }
        
        free(indices);
    }
    
    return self;
}


+ (id) zombieWaveWithDelegate: (id<ZombiesWaveDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
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
        [delegate zombiesWavePassed: self];
    }
}

@end
