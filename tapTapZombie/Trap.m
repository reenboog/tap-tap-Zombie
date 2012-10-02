//
//  Trap.m
//  tapTapZombie
//
//  Created by Alexander on 02.10.12.
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
        body.anchorPoint = ccp(0.5f, 0);
        [self addChild: body];
        
        light = [CCSprite spriteWithFile: @"levels/traps/trap_light.png"];
        light.anchorPoint = ccp(0.5f, 0);
        [self addChild: light];
        
        self.anchorPoint = ccp(0.5f, 0);
        
        [self makeNormal];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) makeNormal
{
    if(status == ts_normal) return;
        
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
    
    status = ts_normal;
}

- (void) makeGreen
{
    if(status == ts_green) return;
        
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(0, 255, 0);
    
    status = ts_green;
}

- (void) makeRed
{
    if(status == ts_red) return;
        
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
    
    status = ts_red;
}

@end
