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

#define kMapsInfoKey    @"mapsInfo"

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
    [self saveMapsInfo];
    
    [maps release];
    [mapsInfo release];
    
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
    
    int mapIndex = 0;
    for(NSDictionary *d in m)
    {
        NSMutableArray *mapsPack = [[NSMutableArray alloc] init];
        
        NSArray *tracks = [d objectForKey: kTracksKey];
        
        int i = 0;
        for(NSArray *ts in tracks)
        {
            NSArray *t = parseTracks(ts);
            [mapsPack addObject: [Map mapWithDifficulty: i tracks: t index: mapIndex]];
            i++;
        }
        
        [maps addObject: [NSArray arrayWithArray: mapsPack]];
        
        [mapsPack release];
        
        mapIndex++;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *data = [defaults objectForKey: kMapsInfoKey];
    if(!data)
    {
        int i = [maps count];
        data = [NSMutableArray arrayWithCapacity: i];
     
//        BOOL isFirstMap = YES;
        while(i > 0)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject: [NSNumber numberWithBool: NO] forKey: @"isPassed"];
            
            [data addObject: dict];
            
            [dict release];
            
            i--;
        }
    }
    
    NSMutableArray *mi = [[NSMutableArray alloc] initWithCapacity: [data count]];
    for(NSDictionary *dict in data)
    {
        [mi addObject: [MapInfo mapInfoWithDictionary: dict]];
    }
    
    mapsInfo = [[NSArray arrayWithArray: mi] retain];
    
    [mi release];
}

- (void) saveMapsInfo
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity: [mapsInfo count]];
    for(MapInfo *mi in mapsInfo)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject: [NSNumber numberWithBool: mi.isPassed] forKey: @"isPassed"];
        
        [data addObject: dict];
        
        [dict release];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: data forKey: kMapsInfoKey];
    
    [defaults synchronize];
    
    [data release];
}

- (Map *) mapAtIndex: (int) index withDifficulty: (int) difficulty
{
    NSAssert(((index < [maps count]) && (index >= 0)), @"wrong map's index %i", index);
    NSAssert(((difficulty >= 0) && (difficulty <= kMaxGameDifficulty)),  @"wrong map's difficulty %i", difficulty);
    
    return [[maps objectAtIndex: index] objectAtIndex: difficulty];
}

- (int) count
{
    return [maps count];
}

- (MapInfo *) mapInfoAtIndex: (int) index
{
    return [mapsInfo objectAtIndex: index];
}

@end
