//
//  MainMenuLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GlobalMapLayer.h"
#import "MapDifficultyPopupDelegate.h"

#import <GameKit/GameKit.h>


@interface MainMenuLayer : CCLayer <CCPopupLayerDelegate, GlobalMapLayerDelegate, MapDifficultyPopupDelegate, GKLeaderboardViewControllerDelegate>
{
    CCMenuItemImage *shopBtn;
    CCMenuItemImage *gameCenterBtn;
    CCMenuItemImage *twitterBtn;
    CCMenuItemImage *facebookBtn;
    CCMenu *topMenu;
    
    GlobalMapLayer *globalMap;
    
    CCSprite *evilDoctor;
    CCLayerColor *blackOut;
    
    int mapIndex;
    
    UIViewController *leaderboardViewController;
}

+ (CCScene *) scene;

@end
