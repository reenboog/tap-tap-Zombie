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

@synthesize isShieldModActivated;

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
        
        [self reset];
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

- (void) reset
{
    [self stopAllActions];
    
    isShieldModActivated = NO;
    
    for(Trap *trap in [self children])
    {
        [trap makeNormal];
        [trap deactivateShieldMod];
    }
}

- (void) setTrapState: (TrapState) state atIndex: (int) index
{
    Trap *trap = (Trap *)[self getChildByTag: index];
    [trap setState: state];
}

- (void) deactivateShieldMod
{
    if(!isShieldModActivated) return;
    
    isShieldModActivated = NO;
    
    for(Trap *trap in [self children])
    {
        [trap deactivateShieldMod];
    }
}

- (void) activateShieldModWithDuration: (ccTime) time
{
    if(isShieldModActivated) return;
    
    isShieldModActivated = YES;
    
    for(Trap *trap in [self children])
    {
        [trap activateShieldMod];
    }
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: time],
                                [CCCallFunc actionWithTarget: self selector: @selector(deactivateShieldMod)],
                                nil
                ]
    ];
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
