//
//  HUD.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "GamePausePopup.h"

#import "GameConfig.h"

#import "Game.h"


@implementation HUD

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        
        CCMenu *menu;
        CCLabelBMFont *label;
        
        label = [CCLabelBMFont labelWithString: @"pause" fntFile: kDefaultGameFont];
        pauseBtn = [CCMenuItemLabel itemWithLabel: label
                                           target: self
                                         selector: @selector(pauseBtnCallback)];
        
        menu = [CCMenu menuWithItems: pauseBtn, nil];
        menu.position = ccp(8.0f + pauseBtn.contentSize.width/2, kScreenHeight - 8.0f - pauseBtn.contentSize.height/2);
        [self addChild: menu];
    }
    
    return self;
}

+ (id) hud
{
    return [[[self alloc] init]  autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

#pragma mark CCPopupLayerDelegate methods implementation
- (void) onPopupOpened
{
    [[Game sharedGame] pauseGame];
    
    [self pauseSchedulerAndActions];
    [self disableWithChildren];
}

- (void) onPopupClosed
{
    [[Game sharedGame] resumeGame];
    
    [self resumeSchedulerAndActionsWithChildren];
    [self enableWithChildren];
}

#pragma mark -

#pragma mark callbacks
- (void) pauseBtnCallback
{
    [GamePausePopup showOnRunningSceneWithDelegate: self];
}

@end
