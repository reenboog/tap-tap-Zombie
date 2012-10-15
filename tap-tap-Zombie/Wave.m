//
//  Wave.m
//  tap-tap-Zombie
//
//  Created by Alexander on 12.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Wave.h"


@implementation Wave

@synthesize paths;
@synthesize weight;
@synthesize tracksNeed;
@synthesize hasJumpers;

- (id) initWithPaths: (NSString *) strPaths
{
    if(self = [super init])
    {
        weight = 0;
        hasJumpers = NO;
        
        NSArray *paths_ = [strPaths componentsSeparatedByString: @","];
        NSMutableArray *tempPaths = [[NSMutableArray alloc] initWithCapacity: [paths_ count]];
        
        int maxTrackIndex = 0;
        for(NSString *p in paths_)
        {
            NSArray *path = [p componentsSeparatedByString: @":"];
            NSMutableArray *tempPath = [[NSMutableArray alloc] initWithCapacity: [path count]];
            
            int w = [path count] - 1;
            w = w < 1 ? 1 : w;
            weight += w;
            
            for(NSString *pp in path)
            {
                int trackNumber = [pp intValue];
                [tempPath addObject: [NSNumber numberWithInt: trackNumber]];
                
                if(trackNumber > maxTrackIndex) maxTrackIndex = trackNumber;
            }
            
            if([path count] > 1)
            {
                hasJumpers = YES;
            }
            
            [tempPaths addObject: tempPath];
            
            [tempPath release];
        }
        
        tracksNeed = maxTrackIndex + 1;
        paths = [[NSArray alloc] initWithArray: tempPaths];
        
        [tempPaths release];
        
//        NSLog(@"tracks: %i; weight: %i;", tracksNeed, weight);
    }
    
    return  self;
}

+ (id) waveWithPaths: (NSString *) strPaths
{
    return [[[self alloc] initWithPaths: strPaths] autorelease];
}

- (void) dealloc
{
    [paths release];
    
    [super dealloc];
}

@end
