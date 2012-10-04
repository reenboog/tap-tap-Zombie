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


#define kMapsCount 7

@implementation GlobalMapLayer

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
            ccp(330, 16), ccp(357, 39), ccp(249, 48), ccp(223, 79), ccp(273, 93), ccp(311, 93), ccp(350, 83)
        };
        
        menu = [CCMenu menuWithItems: nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
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

@end
