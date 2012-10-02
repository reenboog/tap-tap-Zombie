//
//  Wave.m
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Wave.h"

#import "LogicGameItemDelegate.h"


#define kMaxWaveIndex 100
#define kMaxItemIndex 100

@implementation Wave

@synthesize index;
@synthesize nMissingItems;

- (id) init
{
    if(self = [super init])
    {
        static int waveIndex = 0;
        
        index = waveIndex++;
        waveIndex = waveIndex > kMaxWaveIndex ? 0 : waveIndex;
        
        nItems = 0;
        firstTouchTime = 0;
        
        items = [[NSMutableDictionary alloc] init];
        
        nMissingItems = 0;
    }
    
    return self;
}

+ (id) wave
{
    return [[[self alloc] init] autorelease];
}

- (void) dealloc
{
    [items release];
    
    [super dealloc];
}

- (void) addItem: (id<LogicGameItemDelegate>) item
{
    static int itemIndex = 0;
    
    item.wave = index;
    item.index = itemIndex++;
    
    itemIndex = itemIndex > kMaxItemIndex ? 0 : itemIndex;
    
    [items setObject: item forKey: [NSNumber numberWithInt: item.index]];
}

- (void) run
{
    nItems = [items count];
}

- (int) count
{
    return [items count];
}

- (void) removeItem: (id<LogicGameItemDelegate>) item
{
    if([item isMissing]) nMissingItems++;
    
    [items removeObjectForKey: [NSNumber numberWithInt: item.index]];
}

- (void) setOrderIndex: (int) i
{
    orderIndex = i;
    
    id<LogicGameItemDelegate> gameItem = nil;
    NSEnumerator *e = [items objectEnumerator];
    while(gameItem = [e nextObject])
    {
        [gameItem reorder: orderIndex];
    }
}

@end
