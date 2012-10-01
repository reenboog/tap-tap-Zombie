//
//  Level00Background.m
//  tapTapZombie
//
//  Created by Alexander on 23.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Background0.h"

#import "GameConfig.h"


static NSString* resource(NSString *file)
{
    return [NSString stringWithFormat: @"levels/0/%@", file];
}


@interface Background0()

- (void) initClouds;
- (void) initRoads: (int) num;
- (void) initUFOLights;

@end


@implementation Background0

static CCSprite *movableSprite = nil;

#pragma mark init and dealloc
- (id) initWithNumberOfRoads: (int) num
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
        CCSprite *moon = [CCSprite spriteWithFile: @"levels/moon.png"];
        moon.position = ccp(204, 295);
        [self addChild: moon];
        
        CCSprite *moonLight = [CCSprite spriteWithFile: @"levels/moon.png"];
        moonLight.position = ccp(204, 295);
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
        
        // clouds
        [self initClouds];
        
        // ground
        CCSprite *ground = [CCSprite spriteWithFile: resource(@"ground.png")];
        ground.anchorPoint = ccp(0.5f, 0);
        ground.position = ccp(kScreenCenterX, 0);
        [self addChild: ground];
        
        // houses
        CCSprite *house0 = [CCSprite spriteWithFile: resource(@"house0.png")];
        house0.position = ccp(85, 291);
        [self addChild: house0];
        
        CCSprite *house1 = [CCSprite spriteWithFile: resource(@"house1.png")];
        house1.position = ccp(380, 285);
        [self addChild: house1];
        
        // trees
        CGPoint treesPositions[4] = {ccp(40, 252), ccp(203, 281), ccp(375, 243), ccp(439, 219)};
        for(int i = 0; i < 4; i++)
        {
            CCSprite *tree = [CCSprite spriteWithFile: resource([NSString stringWithFormat: @"trees/%i.png", i])];
            tree.anchorPoint = ccp(0.5f, 0);
            tree.position = treesPositions[i];
            [self addChild: tree];
            
            float time = 2.0f + (arc4random()%200)/100.0f;
            float angle = 2.5f;//0.5f + (arc4random()%100)/100.0f;
            angle = arc4random()%2 ? angle : -angle;
            float delayTime = 0.2f + (arc4random()%20)/100.0f;
            [tree runAction: 
                            [CCRepeatForever actionWithAction: 
                                                        [CCSequence actions:
                                                                        [CCDelayTime actionWithDuration: delayTime],
                                                                        [CCEaseSineInOut actionWithAction:
                                                                                    [CCRotateBy actionWithDuration: time 
                                                                                                             angle: angle]
                                                                        ],
                                                                        [CCDelayTime actionWithDuration: delayTime],
                                                                        [CCEaseSineInOut actionWithAction:
                                                                                    [CCRotateBy actionWithDuration: time 
                                                                                                             angle: -angle]
                                                                        ],
                                                                        nil
                                                        ]
                            ]
            ];
        }
        
        // dump
        CCSprite *dump = [CCSprite spriteWithFile: resource(@"dump.png")];
        dump.anchorPoint = ccp(0.5f, 0);
        dump.position = ccp(kScreenCenterX, 0);
        [self addChild: dump];
        
        // ufo lights
        [self initUFOLights];
        
        // roads
        [self initRoads: num];
    }
    
    return self;
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

- (void) animateUFOLight: (CCSprite *) light
{
    [light runAction: 
                    [CCRepeatForever actionWithAction: 
                                                [CCSequence actions:
                                                                [CCFadeIn actionWithDuration: 0.3f],
                                                                [CCDelayTime actionWithDuration: 3.0f],
                                                                [CCFadeOut actionWithDuration: 0.2f],
                                                                [CCDelayTime actionWithDuration: 3.0f],
                                                                nil
                                                ]
                    ]
    ];
}

- (void) initUFOLights
{
    CGPoint pos[3] = {ccp(405, 252), ccp(429, 252), ccp(453, 257)};
    
    for(int i = 0; i < 3; i++)
    {
        CCSprite *light = [CCSprite spriteWithFile: resource(@"light.png")];
        light.position = pos[i];
        [self addChild: light];
        
        light.opacity = 0;
        
        [self performSelector: @selector(animateUFOLight:) withObject: light afterDelay: i*1.0f];
    }
}

+ (id) backgroundWithNumberOfRoads: (int) num
{
    return [[[self alloc] initWithNumberOfRoads: num] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

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

@end
