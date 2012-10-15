//
//  GlobalMapLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "MapCache.h"

#import "GlobalMapLayer.h"
#import "GlobalMapBackgroundLayer.h"

#import "MapDifficultyPopup.h"

#import "MainMenuLayer.h"
#import "GameScene.h"


#define kMapsCount 23

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
            [(CCSprite *)item setOpacity: 0];
            
            BOOL isMapPassed = [[MapCache sharedMapCache] mapInfoAtIndex: i].isPassed;
            if(!isMapPassed)
            {
//                if(isOldMapPassed)
//                {
//                    [(CCSprite *)item setColor: ccc3(0, 255, 0)];
//                }
//                else
//                {
//                    [(CCSprite *)item setOpacity: 100];
//                    item.isEnabled = NO;
//                }
            } 
            
            isOldMapPassed = isMapPassed;
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

#pragma mark GameDifficultyPopupDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [delegate popupWillOpen: popup];
}

- (void) popupDidFinishClosing: (CCPopupLayer *) popup
{
    [delegate popupDidFinishClosing: popup];
}

- (void) setMapDifficulty: (GameDifficulty) mapDifficulty
{
    // start game on map
    Map *map = [[MapCache sharedMapCache] mapAtIndex: mapIndex withDifficulty: mapDifficulty];
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [GameScene gameSceneWithMap: map]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

#pragma mark -

#pragma mark callbacks
- (void) selectMapBtnCallback: (CCNode *) sender
{
    mapIndex = sender.tag;
    
    [MapDifficultyPopup showOnRunningSceneWithDelegate: self];
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
                                                [CCFadeIn actionWithDuration: 0.2f],
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
    ccTime delayTime = ([[selectMapMenu children] count] - 1)*0.06f;
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
        
        delayTime -= 0.06f;
    }
}

@end
