//
//  Background1.m
//  tapTapZombie
//
//  Created by Alexander on 29.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Background3.h"

#import "GameConfig.h"


static NSString* resource(NSString *file)
{
    return [NSString stringWithFormat: @"levels/3/%@", file];
}


@interface Background3()

- (void) initMoon;
- (void) initClouds;
- (void) initRoads: (int) num;

@end


@implementation Background3

static CCSprite *movableSprite = nil;

#pragma mark init and dealloc
- (id) initWithNumberOfTracks: (int) num
{
    if(self = [super init])
    {
        self.isTouchEnabled = YES;
        
        // sky
        CCSprite *sky = [CCSprite spriteWithFile: resource(@"sky.png")];
        sky.anchorPoint = ccp(0.5f, 1);
        sky.position = ccp(kScreenCenterX, kScreenHeight);
        [self addChild: sky];
        
        // moon
        [self initMoon];
        
        // clouds
        [self initClouds];
        
        // ground
        CCSprite *ground = [CCSprite spriteWithFile: resource(@"ground.png")];
        ground.anchorPoint = ccp(0.5f, 0);
        ground.position = ccp(kScreenCenterX, 0);
        [self addChild: ground];
        
        // dump
        CCSprite *dump = [CCSprite spriteWithFile: resource(@"dump.png")];
        dump.anchorPoint = ccp(0.5f, 0);
        dump.position = ccp(kScreenCenterX, 0);
        [self addChild: dump];
        
        // roads
        [self initRoads: num];
    }
    
    return self;
}

- (void) initMoon
{
    CCSprite *moon = [CCSprite spriteWithFile: @"levels/moon.png"];
    moon.position = ccp(413, 708);
    [self addChild: moon];
    
    CCSprite *moonLight = [CCSprite spriteWithFile: @"levels/moon.png"];
    moonLight.position = moon.position;
    [self addChild: moonLight];
    
    moonLight.opacity = 0;
    [moonLight runAction: 
                    [CCRepeatForever actionWithAction: 
                                                [CCSequence actions:
                                                                [CCDelayTime actionWithDuration: 0.5f],
                                                                [CCFadeIn actionWithDuration: 2.0f],
                                                                [CCDelayTime actionWithDuration: 0.5f],
                                                                [CCFadeOut actionWithDuration: 2.0f],
                                                                nil
                                                ]
                    ]
    ];
}

- (void) initClouds
{
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

- (void) initRoads: (int) num
{
    CCSprite *roads = [CCSprite spriteWithFile: resource([NSString stringWithFormat: @"roads/%i.png", num])];
    roads.anchorPoint = ccp(0.5f, 0);
    roads.position = ccp(kScreenCenterX, 0);
    [self addChild: roads];
}

+ (id) backgroundWithNumberOfTracks: (int) num
{
    return [[[self alloc] initWithNumberOfTracks: num] autorelease];
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

