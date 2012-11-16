//
//  GlobalMapLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundsConfig.h"

#import "GameConfig.h"

#import "MapCache.h"

#import "GlobalMapLayer.h"
#import "GlobalMapBackgroundLayer.h"

#import "GameScene.h"

#import "Settings.h"


@implementation GlobalMapLayer

static CCSprite *movableSprite = nil;

#pragma mark init and dealloc
- (id) initWithDelegate: (id<GlobalMapLayerDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
        
        self.isTouchEnabled = YES;
        
        // background
        [self addChild: [GlobalMapBackgroundLayer node]];
        
//        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        // map's points
        CGPoint mapsPositions[kMapsCount] = {
            ccp(330, 16), ccp(357, 39), ccp(249, 48), ccp(223, 79), ccp(273, 93), ccp(311, 93), ccp(350, 83),
            ccp(391, 85), ccp(429, 95), ccp(442, 126), ccp(408, 139), ccp(371, 133), ccp(344, 156), ccp(305, 146),
            ccp(213, 131), ccp(176, 138), ccp(141, 152), ccp(134, 185), ccp(171, 200), ccp(275, 201), ccp(310, 209),
            ccp(342, 230), ccp(374, 249)
        };
        
        selectMapMenu = [CCMenu menuWithItems: nil];
        selectMapMenu.position = ccp(0, 0);
        [self addChild: selectMapMenu];
        BOOL isOldMapPassed = YES;
        for(int i = 0; i < MIN([[MapCache sharedMapCache] count], kMapsCount); i++)
        {
            btnSprite = [CCSprite spriteWithFile: @"globalMap/mapBtn.png"];
            btnOnSprite = [CCSprite spriteWithFile: @"globalMap/mapBtnOn.png"];
            CCMenuItem *item = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                                       selectedSprite: btnOnSprite 
                                                               target: self 
                                                             selector: @selector(selectMapBtnCallback:)];
            item.tag = i;
            
            [selectMapMenu addChild: item];
            
            CGPoint p = mapsPositions[i];
            item.position = ccp(p.x, p.y);
            item.scale = 0;
            
            BOOL isMapPassed = [[MapCache sharedMapCache] mapInfoAtIndex: item.tag].isPassed;
            if(!isMapPassed)
            {
                if(isOldMapPassed)
                {
                    if([Settings sharedSettings].gameCycle > 0)
                    {
                        [(CCSprite *)item setColor: ccc3(255, 0, 0)];
                    }
                    else
                    {
                        [(CCSprite *)item setColor: ccc3(0, 255, 0)];
                    }
                }
                else
                {
                    [(CCSprite *)item setOpacity: 100];
                }
            } 
            
            isOldMapPassed = isMapPassed;
        }
        
        // global map's background top layer
        CCSprite *backgroundTop = [CCSprite spriteWithFile: @"globalMap/globalMapTop.png"];
        backgroundTop.anchorPoint = ccp(0, 0);
        backgroundTop.position = ccp(0, 0);
        [self addChild: backgroundTop];
        
        // firs
        CGPoint positions[kMaxFirs] = {ccp(429, 162), /*ccp(387, 154),*/ ccp(472, 139)};
        isFirsShown = NO;
        for(int i = 0; i < kMaxFirs; i++)
        {
            CCSprite *fir;
            
            NSInteger tag = i;
            fir = [CCSprite spriteWithSpriteFrameName: [NSString stringWithFormat: @"firEmergence%i0.png", tag]];
            fir.tag = tag;
            fir.anchorPoint = ccp(0.5f, 0);
            fir.position = positions[i];
            [self addChild: fir];
            
            firs[i] = fir;
        }
    }
    
    return self;
}

+ (id) globalMapLayerWithDelegate: (id<GlobalMapLayerDelegate>) delegate
{
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark callbacks
- (void) selectMapBtnCallback: (CCNode *) sender
{
    int mapIndex = sender.tag;
    
    BOOL isMapPassed = [[MapCache sharedMapCache] mapInfoAtIndex: mapIndex].isPassed;
    BOOL isOldMapPassed = mapIndex > 0 ? [[MapCache sharedMapCache] mapInfoAtIndex: mapIndex - 1].isPassed : YES;
    
    if(isOldMapPassed || isMapPassed)
    {
        [delegate mapChanged: mapIndex];
    }
    
    PLAY_BUTTON_CLICK_SOUND();
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

- (void) showMapPoints
{
    ccTime delayTime = 0;
    for(CCSprite *item in [selectMapMenu children])
    {
        [item runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: delayTime],
                                    [CCSpawn actions:
                                                [CCEaseBackOut actionWithAction:
                                                                    [CCScaleTo actionWithDuration: 0.3f scale: 1.0f]
                                                ],
                                                nil
                                    ],
                                    nil
                    ]
        ];
        
        delayTime += 0.02f;
    }
}

- (void) animateMapPoints
{
    ccTime delayTime = ([[selectMapMenu children] count] - 1)*0.03f;
    for(CCSprite *item in [selectMapMenu children])
    {
        [item runAction:
                    [CCSequence actions:
                                    [CCDelayTime actionWithDuration: delayTime],
                                    [CCScaleTo actionWithDuration: 0.2f scale: 1.2f],
                                    [CCScaleTo actionWithDuration: 0.2f scale: 1.0f],
                                    nil
                    ]
        ];
        
        delayTime -= 0.03f;
    }
}

#pragma mark -

- (void) showFirs
{
    if(isFirsShown) return;
    
    isFirsShown = YES;
    
    [self runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 5.5f],
                                [CCCallBlock actionWithBlock: ^(void) { isFirsShown = NO; }],
                                nil
                ]
    ];
    
    for(int i = 0; i < kMaxFirs; i++)
    {
        CCSprite *fir = firs[i];
        
        NSString *animationInName = [NSString stringWithFormat: @"firEmergence%i", fir.tag];
        NSString *animationOutName = [NSString stringWithFormat: @"firDisappearence%i", fir.tag];
        CCAnimationCache *ac = [CCAnimationCache sharedAnimationCache];
        CCAction *animationIn = [CCAnimate actionWithAnimation: [ac animationByName: animationInName]
                                          restoreOriginalFrame: NO];
        CCAction *animationOut = [CCAnimate actionWithAnimation: [ac animationByName: animationOutName]
                                           restoreOriginalFrame: NO];
        
        [fir runAction:
                [CCSequence actions:
                                [CCDelayTime actionWithDuration: 0.3f*i],
                                animationIn,
                                [CCDelayTime actionWithDuration: 4.0f],
                                animationOut,
                                nil
                ]
        ];
    }
}

#pragma mark -

@end
