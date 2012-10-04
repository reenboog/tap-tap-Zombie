//
//  TrapsLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TrapsLayer.h"

#import "GameConfig.h"

#import "Map.h"

#import "Trap.h"


@implementation TrapsLayer

#pragma mark init and dealloc
- (id) initWithDelegate: (id<TrapsLayerDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        self.isTouchEnabled = YES;
        
        for(int i = 0; i < delegate.map.nTracks; i++)
        {
            float x = [[delegate.map.tracks[i].keyPoints lastObject] CGPointValue].x;
            
            Trap *trap = [Trap trap];
            trap.position = ccp(x, 0);
            trap.tag = i;
            [self addChild: trap];
        }
    }
    
    return self;
}

+ (id) trapsLayerWithDelegate: (id<TrapsLayerDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

- (void) setTrapState: (TrapState) state atIndex: (int) index
{
    Trap *trap = (Trap *)[self getChildByTag: index];
    [trap setState: state];
}

#pragma mark -

#pragma mark touches
- (void) ccTouchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    for(UITouch *touch in touches)
    {
        for(Trap *trap in [self children])
        {
            if([trap tap: touch])
            {
                [delegate activatedTrapAtIndex: trap.tag];
            }
        }
    }
}

@end
