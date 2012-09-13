//
//  MapCache.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Map.h"


@interface MapCache : NSObject
{
    NSMutableArray *maps;
}

+ (MapCache *) sharedMapCache;
+ (void) releaseMapCache;

- (void) loadMapsWithPlistFile: (NSString *) filename;
- (Map *) mapAtIndex: (int) index withDifficulty: (int) difficulty;
- (int) count;

@end
