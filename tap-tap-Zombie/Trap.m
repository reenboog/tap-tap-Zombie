//
//  Trap.m
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "Trap.h"

#import "AnimationLoader.h"


@implementation Trap

//+ (void) initialize
//{
//    [[CCTextureCache sharedTextureCache] addImage: @"levels/traps/0/gate.png"];
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"levels/traps/0/gate.plist"];
//    
//    [AnimationLoader loadAnimationsWithPlist: @"levels/traps/animations"];
//}

#pragma mark init and dealloc
- (NSString *) resource: (NSString *) r
{
    return [NSString stringWithFormat: @"levels/traps/%i/%@", trapIndex, r];
}

- (NSString *) gateAnimation: (NSString *) an
{
    return [NSString stringWithFormat: @"%@%i", an, trapIndex];
}

- (id) init
{
    if(self = [super init])
    {
        trapIndex = arc4random()%3;
        
        backLight = [CCSprite spriteWithFile: [self resource: @"back_light.png"]];
        backLight.anchorPoint = ccp(0, 0);
        [self addChild: backLight];
        
        gate = [CCSprite node];
        gate.anchorPoint = ccp(0, 0);
        [self addChild: gate];
        [gate runAction: 
                    [CCAnimate actionWithAnimation: [[CCAnimationCache sharedAnimationCache] animationByName: [self gateAnimation: @"openGate"]]
                               restoreOriginalFrame: NO
                    ]
        ];
        
        body = [CCSprite spriteWithFile: [self resource: @"body.png"]];
        body.anchorPoint = ccp(0, 0);
        [self addChild: body];
        
        light = [CCSprite spriteWithFile: [self resource: @"light.png"]];
        light.anchorPoint = ccp(0, 0);
        [self addChild: light];
        
        self.contentSize = CGSizeMake(body.contentSize.width, body.contentSize.height);
        self.anchorPoint = ccp(0.5f, 0);
        
        isShieldModActivated = NO;
        isTrapActivated = NO;
        
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
    if(state == st) return;
    
    switch(st)
    {
        case TrapStateGreen: [self makeGreen]; break;
        case TrapStateRed: [self makeRed]; break;
        default: [self makeNormal]; break;
    }
}

- (void) makeNormal
{
    state = TrapStateNormal;
    
    if(isShieldModActivated) return;
        
    [light stopAllActions];
    light.opacity = 0;
    
    backLight.color = ccc3(255, 250, 65);
}

- (void) makeGreen
{
    state = TrapStateGreen;
    
    if(isShieldModActivated) return;
        
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(0, 255, 0);
    backLight.color = ccc3(0, 255, 0);
}

- (void) makeRed
{
    state = TrapStateRed;
    
    if(isShieldModActivated) return;
        
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
    
    backLight.color = ccc3(255, 0, 0);
}

- (void) activateTrap
{
    if(isTrapActivated) return;
    
    CCAnimate *closeAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: [self gateAnimation: @"closeGate"]]
                                           restoreOriginalFrame: NO];
    
    CCAnimate *openAnimation = [CCAnimate actionWithAnimation: 
                                                    [[CCAnimationCache sharedAnimationCache] animationByName: [self gateAnimation: @"openGate"]]
                                          restoreOriginalFrame: NO];
    
    isTrapActivated = YES;
    
    void (^deactivate)(void) = ^(void) { isTrapActivated = NO; };
    
    void (^showLight)(void) = ^(void) { light.visible = YES; };
    void (^hideLight)(void) = ^(void) { light.visible = NO; };
    
    [gate runAction:
                [CCSequence actions:
                                [CCCallBlock actionWithBlock: hideLight],
                                closeAnimation,
                                openAnimation,
                                [CCCallBlock actionWithBlock: showLight],
                                [CCCallBlock actionWithBlock: deactivate],
                                nil
                ]
    ];
}

- (void) activateShieldMod
{
    if(isShieldModActivated) return;
    
    isShieldModActivated = YES;
    
    [light stopAllActions];
    light.opacity = 255;
    light.color = ccc3(0, 0, 255);
    backLight.color = ccc3(0, 0, 255);
}

- (void) deactivateShieldMod
{
    if(!isShieldModActivated) return;
    
    isShieldModActivated = NO;
    
    switch(state)
    {
        case TrapStateGreen: [self makeGreen]; break;
        case TrapStateRed: [self makeRed]; break;
        default: [self makeNormal]; break;
    }
}

#pragma mark -

- (BOOL) tap: (UITouch *) touch
{
    return [body touchInNode: touch];
}

@end
