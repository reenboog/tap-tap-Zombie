//
//  GlobalMapBackgroundLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "GlobalMapBackgroundLayer.h"

#import "AnimationLoader.h"


@interface GlobalMapBackgroundLayer()

- (void) initSky;
- (void) initMoon;
- (void) initHills;
- (void) initFog;

@end

@implementation GlobalMapBackgroundLayer

static CCSprite *movableSprite = nil;

+ (void) initialize
{
    [[CCTextureCache sharedTextureCache] addImage: @"globalMap/fir.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"globalMap/fir.plist"];
    
    [AnimationLoader loadAnimationsWithPlist: @"globalMap/animations"];
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        [self initSky];
        [self initMoon];
        [self initHills];
        [self initFog];
    }
    
    return self;
}

- (void) initSky
{
    CCSprite *sky = [CCSprite spriteWithFile: @"globalMap/sky.png"];
    sky.anchorPoint = ccp(0.5f, 1);
    sky.position = ccp(kScreenCenterX, kScreenHeight);
    [self addChild: sky];
    
    clouds = [CCSprite spriteWithFile: @"clouds/clouds.png"];
    clouds.anchorPoint = ccp(0, 1);
    clouds.position = ccp(0, kScreenHeight);
    [self addChild: clouds];
    
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
    [clouds.texture setTexParameters: &tp];
    
    [self schedule: @selector(updateClouds:)];
}

- (void) updateClouds: (ccTime) dt
{
    static float shift = 0;
    shift += 24.0f*dt;
    if(shift > clouds.contentSize.width)
    {
        shift = shift - clouds.contentSize.width;
    }
    
    [clouds setTextureRect: CGRectMake(shift, 0, clouds.contentSize.width, clouds.contentSize.height)];
}

- (void) initMoon
{
    CCSprite *moon = [CCSprite spriteWithFile: @"globalMap/moon.png"];
    moon.position = ccp(145, 270);
    [self addChild: moon];
    
    [moon runAction:
                [CCRepeatForever actionWithAction:
                                        [CCSequence actions:
                                                        [CCMoveBy actionWithDuration: 2.0f position: ccp(0, 4.0f)],
                                                        [CCMoveBy actionWithDuration: 1.5f position: ccp(0, -4.0f)],
                                                        nil
                                        ]
                ]
    ];
}

- (void) initHills
{
    CCSprite *hills = [CCSprite spriteWithFile: @"globalMap/hills.png"];
    hills.anchorPoint = ccp(0.5f, 0);
    hills.position = ccp(kScreenCenterX, 0);
    [self addChild: hills];
}

- (void) initFog
{
    CCSprite *fog0 = [CCSprite spriteWithFile: @"globalMap/fog0.png"];
    fog0.anchorPoint = ccp(0, 0.5f);
    fog0.position = ccp(0, 170.0f);
    [self addChild: fog0];
    
    CCSprite *fog1 = [CCSprite spriteWithFile: @"globalMap/fog1.png"];
    fog1.anchorPoint = ccp(0, 0.5f);
    fog1.position = ccp(0, 170.0f);
    [self addChild: fog1];
    
    fog1.opacity = 0;
    
//    fog0.color = ccc3(0, 100, 0);
//    fog1.color = ccc3(0, 100, 0);
    
    [fog0 runAction:
                [CCRepeatForever actionWithAction:
                                        [CCSequence actions:
                                                        [CCFadeOut actionWithDuration: 3.0f],
                                                        [CCFadeIn actionWithDuration: 3.0f],
                                                        nil
                                        ]
                ]
    ];
    
    [fog1 runAction:
                [CCRepeatForever actionWithAction:
                                        [CCSequence actions:
                                                        [CCFadeIn actionWithDuration: 3.0f],
                                                        [CCFadeOut actionWithDuration: 3.0f],
                                                        nil
                                        ]
                ]
    ];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark touches
- (void) ccTouchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
    if(!movableSprite) return;
    
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    CGPoint p = [movableSprite.parent convertToNodeSpace: location];
    
    CCLOG(@"%.0f, %.0f", p.x, p.y);
    
    movableSprite.position = ccp(p.x, p.y);
}

#pragma mark -

@end
