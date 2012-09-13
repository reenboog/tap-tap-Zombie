//
//  GameLogic.m
//  tapTapZombie
//
//  Created by Alexander on 10.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"

#import "GameLogic.h"
#import "LogicGameItemDelegate.h"

#import "Wave.h"


static const float minMovingTime[kMaxGameDifficulty + 1] = {1.5f, 1.3f, 1.2f, 1.0f};
static const float maxMovingTime[kMaxGameDifficulty + 1] = {2.5f, 2.3f, 2.1f, 1.8f};

static const float minStandingTime[kMaxGameDifficulty + 1] = {1.2f, 1.0f, 0.9f, 0.7f};
static const float maxStandingTime[kMaxGameDifficulty + 1] = {2.0f, 1.8f, 1.5f, 1.2f};

static const float timeForDifficultyGrowth[kMaxGameDifficulty + 1] = {180.0f, 160.0f, 140.0f, 120.0f};

#define kMinSuccess -100.0f
#define kMaxSuccess 100.0f


@implementation GameLogic

@synthesize delegate;

@synthesize map;
@synthesize success;
@synthesize perfectWaves;

- (id) initWithMap: (Map *) map_
{
    if(self = [super init])
    {
        map = [map_ retain];
        
        waves = [[NSMutableArray alloc] init];
        
        [self reset];
    }
    
    return self;
}

+ (id) gameLogicWithMap: (Map *) map
{
    return [[[self alloc] initWithMap: map] autorelease];
}

- (void) dealloc
{
    [map release];
    [waves release];
    
    [super dealloc];
}

#pragma mark -

#pragma mark reset
- (void) reset
{
    success = 0;
    
    timer = 0;
    
    currentMovingTime = maxMovingTime[map.difficulty];
    currentStandingTime = maxStandingTime[map.difficulty];
    
    perfectWaves = 0;
}

#pragma mark -

#pragma mark game
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

- (void) newGameWave
{
    int N = arc4random()%(map.nTracks) + 1;
    int *indices = malloc(map.nTracks*sizeof(int));
    for(int i = 0; i < map.nTracks; i++)
    {
        indices[i] = i;
    }
    
    shuffleArray(indices, map.nTracks);
    
    Wave *wave = [Wave wave];
    for(int i = 0; i < N; i++)
    {
        int index = indices[i];
        Track track = map.tracks[index];
        id<LogicGameItemDelegate> item = [delegate runGameItemWithTrack: track 
                                                             movingTime: currentMovingTime 
                                                           standingTime: currentStandingTime];
        
        [wave addItem: item];
    }
    [waves addObject: wave];
    [wave run];
    
    free(indices);
}

- (void) increaseDifficulty: (float) dt
{
    int di = map.difficulty;
    
    float difficultyPerSecond = (maxMovingTime[di] - minMovingTime[di])/timeForDifficultyGrowth[di];
    currentMovingTime -= difficultyPerSecond*dt;
    currentMovingTime = currentMovingTime < minMovingTime[map.difficulty] ? minMovingTime[map.difficulty] : currentMovingTime;
    
    difficultyPerSecond = (maxStandingTime[di] - minStandingTime[di])/timeForDifficultyGrowth[di];
    currentStandingTime -= difficultyPerSecond*dt;
    currentStandingTime = currentStandingTime < minStandingTime[map.difficulty] ? minStandingTime[map.difficulty] : currentStandingTime;
}

#pragma mark -

#pragma mark GameLayerLogicDelegate methods implementation
- (void) tick: (float) dt
{
    const static int timePerGameIteration = 2.0f;
    static BOOL flag = NO;
    
    timer -= dt;
    
    if(timer < 0)
    {
        timer = timePerGameIteration;
        
        if(arc4random()%2 || flag)
        {
            [self newGameWave];
            
            flag = NO;
        }
        else
        {
            flag = YES;
        }
    }
    
    [self increaseDifficulty: dt];
}

#pragma mark -

#pragma mark GameItemLogicDelegate methods implementation
- (void) gameItemDisappears: (id<LogicGameItemDelegate>) item
{
    float award = 5;
    
    if([item isMissing])
    {
        award = -award;
    }
    
    success += award;
    
    success = success < kMinSuccess ? kMinSuccess : success > kMaxSuccess ? kMaxSuccess : success;
    
    Wave *wave = nil;
    for(wave in waves) if(item.wave == wave.index) break;
    [wave removeItem: item];
    
    if([wave count] < 1)
    {
        if(wave.nMissingItems == 0)
        {
            perfectWaves = perfectWaves + 1;
//            CCLOG(@"perfect wave");
        }
        else
        {
            perfectWaves = 0;
        }
        
        [waves removeObject: wave];
        
//        CCLOG(@"wave ended");
    }
}

#pragma mark -

#pragma mark additional
- (float) currentMovingTime
{
    return currentMovingTime;
}

- (float) currentStandingTime
{
    return  currentStandingTime;
}

- (float) maxMovingTime
{
    return maxMovingTime[map.difficulty];
}

- (float) minMovingTime
{
    return minMovingTime[map.difficulty];
}

- (float) maxStandingTime
{
    return maxStandingTime[map.difficulty];
}

- (float) minStandingTime
{
    return minStandingTime[map.difficulty];
}

@end
