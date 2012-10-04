//
//  MapCache.m
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "MapCache.h"


@interface MapCache()

- (void) loadMapsWithPlistFile: (NSString *) filename;

@end


#define kMapsKey        @"maps"
#define kTracksKey      @"tracks"
#define kBackgroundKey  @"background"

@implementation MapCache

#pragma mark singleton part
static MapCache *sharedMapCache = nil;

+ (MapCache *) sharedMapCache
{
    if(!sharedMapCache)
    {
        sharedMapCache = [[self alloc] init];
    }
    
    return sharedMapCache;
}

+ (void) releaseMapCache
{
    [sharedMapCache release];
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        maps = [[NSMutableArray alloc] init];
        [self loadMapsWithPlistFile: @"maps"];
    }
    
    return self;
}

- (void) dealloc
{
    [maps release];
    
    [super dealloc];
}

#pragma mark -

NSArray* parseTracks(NSArray *tracks)
{
    NSMutableArray *ts = [[NSMutableArray alloc] init];
    
    for(NSArray *track in tracks)
    {
        NSMutableArray *keyPoints = [[NSMutableArray alloc] initWithCapacity: 10];
        
        for(NSString *s in track)
        {
            NSArray *ap = [s componentsSeparatedByString: @","];
            CGPoint p = CGPointMake([[ap objectAtIndex: 0] floatValue], [[ap objectAtIndex: 1] floatValue]);
            
            [keyPoints addObject: [NSValue valueWithCGPoint: p]];
        }
        
        [ts addObject: [NSArray arrayWithArray: keyPoints]];
        
        [keyPoints release];
    }
    
    NSArray *r = [NSArray arrayWithArray: ts];
    [ts release];
    
    return  r;
}

- (void) loadMapsWithPlistFile: (NSString *) filename
{
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] 
                                                                           pathForResource: filename 
                                                                           ofType: @"plist"]];
    NSAssert(plistDict, @"no such file '%@'.", filename);
    
    NSArray *m = [plistDict objectForKey: kMapsKey];
    
    for(NSDictionary *d in m)
    {
        NSMutableArray *mapsPack = [[NSMutableArray alloc] init];
        
        NSString *background = [d objectForKey: kBackgroundKey];
        NSArray *tracks = [d objectForKey: kTracksKey];
        
        int i = 0;
        for(NSArray *ts in tracks)
        {
            NSArray *t = parseTracks(ts);
            [mapsPack addObject: [Map mapWithDifficulty: i tracks: t background: background]];
            i++;
        }
        
        [maps addObject: [NSArray arrayWithArray: mapsPack]];
        
        [mapsPack release];
    }
}

- (Map *) mapAtIndex: (int) index withDifficulty: (int) difficulty
{
    NSAssert(((index < [maps count]) && (index >= 0)), @"wrong map's index value %i", index);
    NSAssert(((difficulty >= 0) && (difficulty <= kMaxGameDifficulty)),  @"wrong difficulty value %i", difficulty);
    
    return [[maps objectAtIndex: index] objectAtIndex: difficulty];
}

- (int) count
{
    return [maps count];
}

@end
