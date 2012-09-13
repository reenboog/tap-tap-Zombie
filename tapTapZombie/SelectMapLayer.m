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
        CCLabelBMFont *label;
        
        label = [CCLabelBMFont labelWithString: @"main menu" fntFile: kDefaultGameFont];
        backBtn = [CCMenuItemLabel itemWithLabel: label target: self selector: @selector(backBtnCallback)];
        CCMenu *menu = [CCMenu menuWithItems: backBtn, nil];
        menu.position = ccp(kScreenCenterX, 24.0f);
        [self addChild: menu];
        
        selectMapMenu = [CCMenu menuWithItems: nil];
        selectMapMenu.position = ccp(kScreenCenterX, kScreenCenterY + 24.0f);
        [self addChild: selectMapMenu];
        for(int i = 0; i < [[MapCache sharedMapCache] count]; i++)
        {
            label = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"map %i", i] fntFile: kDefaultGameFont];
            CCMenuItem *item = [CCMenuItemLabel itemWithLabel: label target: self selector: @selector(selectMapBtnCallback:)];
            item.tag = i;
            
            [selectMapMenu addChild: item];
        }
        [selectMapMenu alignItemsVertically];
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
