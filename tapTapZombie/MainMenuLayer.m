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
        CCLabelBMFont *label;
        
        // main menu
        label = [CCLabelBMFont labelWithString: @"play" fntFile: kDefaultGameFont];
        playBtn = [CCMenuItemLabel itemWithLabel: label
                                          target: self
                                        selector: @selector(playBtnCallback)];
        
        label = [CCLabelBMFont labelWithString: @"shop" fntFile: kDefaultGameFont];
        shopBtn = [CCMenuItemLabel itemWithLabel: label
                                          target: self
                                        selector: @selector(shopBtnCallback)];
        
        menu = [CCMenu menuWithItems: playBtn, shopBtn, nil];
        [menu alignItemsVertically];
        menu.position = kScreenCenter;
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
