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
            ccp(675, 58), ccp(757, 153),
            ccp(524, 196), ccp(472, 255),
            ccp(579, 278), ccp(672, 274), ccp(761, 255), ccp(852, 270), ccp(940, 297), ccp(919, 367), ccp(839, 375), ccp(771, 399), ccp(696, 406), ccp(615, 396),
            ccp(443, 363), ccp(360, 379), ccp(287, 423), ccp(307, 493), ccp(386, 516),
            ccp(586, 523), ccp(673, 531), ccp(731, 584), ccp(802, 617)
        };
        
        selectMapMenu = [CCMenu menuWithItems: nil];
        selectMapMenu.position = ccp(0, 0);
        [self addChild: selectMapMenu];
        BOOL isOldMapPassed = YES;
        int mapsCount = MIN([[MapCache sharedMapCache] count], kMapsCount);
        for(int i = 0; i < mapsCount; i++)
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
            
//            movableSprite = item;
        }
        
        // global map's background top layer
        CCSprite *backgroundTop = [CCSprite spriteWithFile: @"globalMap/globalMapTop.png"];
        backgroundTop.anchorPoint = ccp(0, 0);
        backgroundTop.position = ccp(0, 0);
        [self addChild: backgroundTop];
        
        // firs
        CGPoint positions[kMaxFirs] = {ccp(916, 427), ccp(990, 388)};
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
            
            movableSprite = fir;
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
