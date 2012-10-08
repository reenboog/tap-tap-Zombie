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
            
            if(index < 0) continue;
            
            Track track = map.tracks[index];
            NSArray *keyPoints = track.keyPoints;
            
            ZombieType zombieType;
            
            if((i == 0) && (arc4random()%4 == 0))
            {
                zombieType = ZombieTypeJumper;
                
                NSMutableArray *kp = [NSMutableArray array];
                int si = arc4random()%2 ? index - 1 : index + 1;
                si = si < 0 ? 1 : si > map.nTracks - 1 ? map.nTracks - 2 : si;
                
                for(int j = 0; j < N; j++)
                {
                    if(indices[j] == si)
                    {
                        indices[j] = -1;
                        break;
                    }
                }
                
                NSArray *kp0 = map.tracks[si].keyPoints;
                
                int sep0 = [keyPoints count]*2/3;
                int sep1 = 0;
                
                float y0 = [[keyPoints objectAtIndex: sep0] CGPointValue].y;
                while(true)
                {
                    float y1 = [[kp0 objectAtIndex: sep1] CGPointValue].y;
                    
                    if(y0 > y1) break;
                    
                    sep1++;
                }
                
                for(int j = 0; j < sep0; j++)
                {
                    [kp addObject: [keyPoints objectAtIndex: j]];
                }
                
                for(int j = sep1; j < [kp0 count]; j++)
                {
                    [kp addObject: [kp0 objectAtIndex: j]];
                }
                
                keyPoints = [NSArray arrayWithArray: kp];
                index = si;
            } 
            else if(arc4random()%3)
            {
                zombieType = ZombieTypeNormal;
            }
            else if(!(arc4random()%5) && !delegate.isShieldModActivated)
            {
                zombieType = ZombieTypeShield;
            }
            else
            {
                zombieType = ZombieTypeBad;
            }
            
            Zombie *zombie = [Zombie zombieWithDelegate: self type: zombieType];
            zombie.tag = index;
            [self addChild: zombie];
            
            [zombie runWithKeyPoints: keyPoints movingTime: 2.0f standingTime: 0.6f];
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

- (void) zombieCaptured: (Zombie *) zombie
{
    [delegate zombieCaptured: zombie];
}

@end
