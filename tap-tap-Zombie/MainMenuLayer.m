//
//  MainMenuLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import "MainMenuLayer.h"
#import "ShopPopup.h"

#import "GlobalMapLayer.h"

#import "WaveCache.h"


@implementation MainMenuLayer

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    MainMenuLayer *mainMenuLayer = [MainMenuLayer node];
    
    [scene addChild: mainMenuLayer];
    
    return scene;
}

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        [WaveCache sharedWaveCache];
        
        // main menu
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/playBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/playBtnOn.png"];
        playBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self
                                                selector: @selector(playBtnCallback)];
        playBtn.anchorPoint = ccp(0.5f, 0);
        
        btnSprite = [CCSprite spriteWithFile: @"buttons/shopBtn.png"];
        btnOnSprite = [CCSprite spriteWithFile: @"buttons/shopBtnOn.png"];
        shopBtn = [CCMenuItemSprite itemFromNormalSprite: btnSprite
                                          selectedSprite: btnOnSprite
                                                  target: self
                                                selector: @selector(shopBtnCallback)];
        shopBtn.anchorPoint = ccp(0.5f, 0);
        shopBtn.scale = 0.7f;
        
        menu = [CCMenu menuWithItems: shopBtn, playBtn, nil];
        [menu alignItemsHorizontally];
        menu.position = ccp(kScreenWidth + 8.0f - playBtn.contentSize.width, 8.0f);
        [self addChild: menu];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) popupWillOpen: (CCPopupLayer *) popup
{
    [self disableWithChildren];
}

- (void) popupDidFinishClosing: (CCPopupLayer *) popup
{
    [self enableWithChildren];
}

#pragma mark -

#pragma mark callbacks
- (void) playBtnCallback
{
    CCTransitionFade *sceneTransition = [CCTransitionFade transitionWithDuration: 0.3f
                                                                           scene: [GlobalMapLayer scene]
                                                                       withColor: ccc3(0, 0, 0)];
    
    [[CCDirector sharedDirector] replaceScene: sceneTransition];
}

- (void) shopBtnCallback
{
    [ShopPopup showOnRunningSceneWithDelegate: self];
}

@end
