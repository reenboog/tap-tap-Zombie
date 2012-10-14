//
//  WaveCache.m
//  tap-tap-Zombie
//
//  Created by Alexander on 12.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaveCache.h"

#import "Wave.h"


@implementation WaveCache

+ (WaveCache *) sharedWaveCache
{
    static WaveCache *sharedWaveCache = nil;
    
    if(!sharedWaveCache)
    {
        sharedWaveCache = [[self alloc] init];
    }
    
    return sharedWaveCache;
}

- (id) init
{
    if(self = [super init])
    {
        NSMutableArray *tempWaves = [[NSMutableArray alloc] init];
        
        
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] 
                                                                               pathForResource: @"waves" 
                                                                               ofType: @"plist"]];
        NSAssert(plistDict, @"no such file 'waves.plist'.");
        NSArray *m = [plistDict objectForKey: @"waves"];
       
        for(NSString *p in m)
        {
            [tempWaves addObject: [Wave waveWithPaths: p]];
        }
        
        waves = [[NSArray alloc] initWithArray: tempWaves];
        
        [tempWaves release];
    }
    
    return self;
}

- (void) dealloc
{
    [waves release];
    
    [super dealloc];
}

- (Wave *) randomWaveWithWeight: (int) w maxTracks: (int) mt jumpersAllowed: (BOOL) ja
{
    NSArray *res;
    NSArray *temp;
    
    BOOL (^evaluatedByMaxTracks)(id obj, NSDictionary *bindings) = ^(id obj, NSDictionary *bindings) {
        return (BOOL)(((Wave *)obj).tracksNeed <= mt);
    };
    
    BOOL (^evaluatedByWeight)(id obj, NSDictionary *bindings) = ^(id obj, NSDictionary *bindings) {
        return (BOOL)(((Wave *)obj).weight == w);
    };
    
    BOOL (^evaluatedByJumpers)(id obj, NSDictionary *bindings) = ^(id obj, NSDictionary *bindings) {
        if(ja) return YES;
        return (BOOL)(((Wave *)obj).hasJumpers == NO);
    };
    
    NSPredicate *maxTracksPredicate = [NSPredicate predicateWithBlock: evaluatedByMaxTracks];
    NSPredicate *weightPredicate = [NSPredicate predicateWithBlock: evaluatedByWeight];
    NSPredicate *jumpersPredicate = [NSPredicate predicateWithBlock: evaluatedByJumpers];
    
    res = [waves filteredArrayUsingPredicate: maxTracksPredicate];
    
    temp = [res filteredArrayUsingPredicate: weightPredicate];
    temp = [temp filteredArrayUsingPredicate: jumpersPredicate];
    
    if([temp count] > 0)
    {
        res = temp;
    }
    
    int index = arc4random()%[res count];
    
    return [res objectAtIndex: index];
}

@end
