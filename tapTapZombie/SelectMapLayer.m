//
//  SelectMapLayer.m
//  tapTapZombie
//
//  Created by Alexander on 12.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectMapLayer.h"
#import "GameConfig.h"

#import "Game.h"
#import "MapCache.h"

#import "GameDifficultyPopup.h"


#define kMaxMaps 7

@implementation SelectMapLayer

#pragma mark scene
+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    SelectMapLayer *layer = [SelectMapLayer node];
    
    [scene addChild: layer];
    
    return scene;
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        CCSprite *backgroundSprite = [CCSprite spriteWithFile: @"globalMap/mapBackground.png"];
        backgroundSprite.position = kScreenCenter;
        [self addChild: backgroundSprite];
        
        CCMenu *menu;
//        CCLabelBMFont *label;
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
        
        // maps btns
        CGPoint mapsPositions[kMaxMaps] = {
            ccp(330, 16), ccp(357, 39), ccp(249, 48), ccp(223, 79), ccp(273, 93), ccp(311, 93), ccp(350, 83)
        };
        
        menu = [CCMenu menuWithItems: nil];
        menu.position = ccp(0, 0);
        [self addChild: menu];
        for(int i = 0; i < MIN([[MapCache sharedMapCache] count], kMaxMaps); i++)
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
            item.position = ccp(p.x, p.y);//ccp(p.x + item.contentSize.width/2, p.y + item.contentSize.height/2);
        }
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark callbacks
- (void) backBtnCallback
{
    [[Game sharedGame] runMainMenuScene];
}

- (void) selectMapBtnCallback: (CCNode *) sender
{
    int mapIndex = sender.tag;
    
    [Game sharedGame].mapIndex = mapIndex;
    
    [GameDifficultyPopup showOnRunningSceneWithDelegate: self];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
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

@end
