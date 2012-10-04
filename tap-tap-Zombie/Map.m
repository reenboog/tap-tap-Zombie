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
@synthesize background;

- (id) initWithDifficulty: (int) d tracks: (NSArray *) t background: (NSString *) b
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
        background = [b retain];
        nTracks = [t count];
    
        tracks = malloc(sizeof(Track)*nTracks);
        for(int i = 0; i < nTracks; i++)
        {
            tracks[i].keyPoints = [[t objectAtIndex: i] retain];
        }
    }
    
    return self;
}

+ (id) mapWithDifficulty: (int) d tracks: (NSArray *) t background: (NSString *) b
{
    return [[[self alloc] initWithDifficulty: d tracks: t background: b] autorelease];
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
        
    // background
    NSString *b = [dict objectForKey: kMapBackgroundKey];
    NSAssert(b, 
            @"invalid dictionary structure: object for key '%@' is nil.", 
            kMapBackgroundKey);
    
    return [self initWithDifficulty: d tracks: t background: b];
}

+ (id) mapWithDictionary: (NSDictionary *) dict
{
    return [[[self alloc] initWithDictionary: dict] autorelease];
}

- (void) dealloc
{
    [background release];
    
    for(int i = 0; i < nTracks; i++)
    {
        [tracks[i].keyPoints release];
    }
    
    free(tracks);
    
    [super dealloc];
}

@end
