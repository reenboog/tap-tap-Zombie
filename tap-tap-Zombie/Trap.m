//
//  Trap.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Trap.h"

#import "GameConfig.h"


@implementation Trap

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        body = [CCSprite spriteWithFile: @"levels/traps/trap.png"];
        body.anchorPoint = ccp(0, 0);
        [self addChild: body];
        
        light = [CCSprite spriteWithFile: @"levels/traps/trap_light.png"];
        light.anchorPoint = ccp(0, 0);
        [self addChild: light];
        
        self.contentSize = CGSizeMake(body.contentSize.width, body.contentSize.height);
        
        self.anchorPoint = ccp(0.5f, 0);
        
        [self makeNormal];
    }
    
    return self;
}

+ (id) trap
{
    return [[[self alloc] init] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) setState: (TrapState) st
{
    switch(st)
    {
        case TrapStateGreen: [self makeGreen]; break;
        case TrapStateRed: [self makeRed]; break;
        default: [self makeNormal]; break;
    }
}

- (void) makeNormal
{
    if(state == TrapStateNormal) return;
        
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(255, 255, 255);
    [light runAction: 
                [CCRepeatForever actionWithAction:
                                        [CCSequence actions:
                                                        [CCFadeOut actionWithDuration: 0.5f],
                                                        [CCFadeIn actionWithDuration: 0.3f],
                                                        nil
                                        ]
                ]
    ];
    
    state = TrapStateNormal;
}

- (void) makeGreen
{
    if(state == TrapStateGreen) return;
        
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(0, 255, 0);
    
    state = TrapStateGreen;
}

- (void) makeRed
{
    if(state == TrapStateRed) return;
        
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(255, 0, 0);
    [light runAction: 
                [CCRepeatForever actionWithAction:
                                        [CCSequence actions:
                                                        [CCFadeOut actionWithDuration: 0.2f],
                                                        [CCFadeIn actionWithDuration: 0.2f],
                                                        [CCDelayTime actionWithDuration: 0.2f],
                                                        nil
                                        ]
                ]
    ];
    
    state = TrapStateRed;
}

#pragma mark -

- (BOOL) tap: (UITouch *) touch
{
    return [body touchInNode: touch];
}

@end
