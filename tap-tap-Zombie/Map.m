//
//  Map.m
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "Map.h"


@implementation Map

@synthesize difficulty;
@synthesize nTracks;
@synthesize tracks;
@synthesize index;

- (id) initWithDifficulty: (int) d tracks: (NSArray *) t index: (int) i
{
    if(self = [super init])
    {
        NSAssert(((([t count] >= kMinGameWays) && ([t count] <= kMaxGameWays))),
                 @"invalid dictionary structure: ['%@' count] return wrong value %i.", 
                 kMapTracksKey, [t count]);
        
        NSAssert(((d >= 0) && (d <= kMaxGameDifficulty)), 
                 @"invalid dictionary structure: number for key '%@' have wrong value %i.", 
                 kMapDifficultyKey, d);
        
        difficulty = d;
        index = i;
        nTracks = [t count];
    
        tracks = malloc(sizeof(Track)*nTracks);
        for(int i = 0; i < nTracks; i++)
        {
            tracks[i].keyPoints = [[t objectAtIndex: i] retain];
        }
    }
    
    return self;
}

+ (id) mapWithDifficulty: (int) d tracks: (NSArray *) t index: (int) index
{
    return [[[self alloc] initWithDifficulty: d tracks: t index: index] autorelease];
}

- (id) initWithDictionary: (NSDictionary *) dict
{
    NSAssert(dict, @"dictionary object is nil");
    
    // ways
    NSArray *t = [dict objectForKey: kMapTracksKey];
    NSAssert(t, 
             @"invalid dictionary structure: object for key '%@' is nil.", 
             kMapTracksKey);
    
    // difficulty
    NSNumber *n = [dict objectForKey: kMapDifficultyKey];
    NSAssert(n, 
             @"invalid dictionary structure: object for key '%@' is nil.", 
             kMapDifficultyKey);
    
    int d = [n intValue];
        
    // index
    NSNumber *ni = [dict objectForKey: kMapIndexKey];
    NSAssert(ni, 
            @"invalid dictionary structure: object for key '%@' is nil.", 
            kMapIndexKey);
    
    return [self initWithDifficulty: d tracks: t index: [ni intValue]];
}

+ (id) mapWithDictionary: (NSDictionary *) dict
{
    return [[[self alloc] initWithDictionary: dict] autorelease];
}

- (void) dealloc
{
    for(int i = 0; i < nTracks; i++)
    {
        [tracks[i].keyPoints release];
    }
    
    free(tracks);
    
    [super dealloc];
}

@end



@implementation MapInfo

@synthesize isPassed;
@synthesize score;

- (id) initWithDictionary: (NSDictionary *) dict
{
    if(self = [super init])
    {
        isPassed = [[dict objectForKey: @"isPassed"] boolValue];
        score = [[dict objectForKey: @"score"] floatValue];
    }
    
    return self;
}

+ (id) mapInfoWithDictionary: (NSDictionary *) dict
{
    return [[[self alloc] initWithDictionary: dict] autorelease];
}

@end
