//
//  HelloWorldLayer.m
//  tapTapZombie
//
//  Created by Alexander on 16.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "GameConfig.h"

#import "MainMenuLayer.h"

#import "SelectGameDifficultyPopup.h"


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
        
        menu = [CCMenu menuWithItems: playBtn, nil];
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
- (void) onPopupOpened
{
    [self disableWithChildren];
}

- (void) onPopupClosed
{
    [self enableWithChildren];
}

#pragma mark -

#pragma mark callbacks
- (void) playBtnCallback
{
    [SelectGameDifficultyPopup showOnRunningSceneWithDelegate: self];
}

@end
