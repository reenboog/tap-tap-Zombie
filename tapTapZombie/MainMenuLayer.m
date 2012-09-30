//
//  HelloWorldLayer.m
//  tapTapZombie
//
//  Created by Alexander on 16.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "GameConfig.h"
#import "MainMenuLayer.h"

#import "Game.h"

#import "SelectMapLayer.h"
#import "ShopPopup.h"


@implementation MainMenuLayer

#pragma mark scene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	[scene addChild: [MainMenuLayer node]];
	
	return scene;
}

#pragma mark -

#pragma mark init and dealloc
-(id) init
{
	if(self = [super init])
    {
        CCMenu *menu;
        CCSprite *btnSprite;
        CCSprite *btnOnSprite;
        
        // main menu
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
    [[Game sharedGame] runSelectMapScene];
}

- (void) shopBtnCallback
{
    [ShopPopup showOnRunningSceneWithDelegate: self];
}

@end
