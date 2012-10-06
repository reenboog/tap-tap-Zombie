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

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GlobalMapLayer *globalMapLayer = [GlobalMapLayer node];
    
    [scene addChild: globalMapLayer];
    
    return scene;
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        self.isTouchEnabled = YES;
        
        // background
        [self addChild: [GlobalMapBackgroundLayer node]];
        
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        // back btn
        btnSprite = [CCSprite spriteWithFile: @"buttons/returnBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/returnBtnOn.png"];
        backBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite 
                                                  target: self 
                                                selector: @selector(backBtnCallback)];
        menu = [CCMenu menuWithItems: backBtn, nil];
        menu.position = ccp(8.0f + backBtn.contentSize.width/2, 8.0f + backBtn.contentSize.height/2);
        [self addChild: menu];
        
        // map's points
        CGPoint mapsPositions[kMapsCount] = {
            ccp(330, 16), ccp(357, 39), ccp(249, 48), ccp(223, 79), ccp(273, 93), ccp(311, 93), ccp(350, 83),
            ccp(391, 85), ccp(429, 95), ccp(442, 126), ccp(408, 139), ccp(371, 133), ccp(344, 156), ccp(305, 146),
            ccp(213, 131), ccp(176, 138), ccp(141, 152), ccp(134, 185), ccp(171, 200), ccp(275, 201), ccp(310, 209),
            ccp(342, 230), ccp(374, 249)
        };
        
        menu = [CCMenu menuWithItems: nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
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
            
            [menu addChild: item];
            
            CGPoint p = mapsPositions[i];
            item.position = ccp(p.x, p.y);
            
            BOOL isMapPassed = [[MapCache sharedMapCache] mapInfoAtIndex: i].isPassed;
            if(!isMapPassed)
            {
                if(isOldMapPassed)
                {
                    [(CCSprite *)item setColor: ccc3(0, 255, 0)];
                }
                else
                {
                    [(CCSprite *)item setOpacity: 100];
                    item.isEnabled = NO;
                }
            } 
            
            isOldMapPassed = isMapPassed;
            
//            movableSprite = (CCSprite *)item;
        }
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark GameDifficultyPopupDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [self pauseSchedulerAndActionsWithChildren];
    [self disableWithChildren];
}

- (void) popupDidFinishClosing: (CCPopupLayer *) popup
{
    [self resumeSchedulerAndActionsWithChildren];
    [self enableWithChildren];
}

- (void) setMapDifficulty: (GameDifficulty) mapDifficulty
{
//    int backgroundIndex = 0;
//    if(mapIndex < 2) backgroundIndex = 0;
//    else if(mapIndex < 4) backgroundIndex = 1;
//    else backgroundIndex = 2;
    
    // start game on map
    Map *map = [[MapCache sharedMapCache] mapAtIndex: mapIndex withDifficulty: mapDifficulty];
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [GameScene gameSceneWithMap: map]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

#pragma mark -

#pragma mark callbacks
- (void) backBtnCallback
{
    // go back to main menu
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [MainMenuLayer scene]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

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

@end
