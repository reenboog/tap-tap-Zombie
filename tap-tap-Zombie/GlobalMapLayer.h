//
//  GlobalMapLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MapDifficultyPopupDelegate.h"

#import "GlobalMapLayerDelegate.h"


#define kMaxFirs 2

@interface GlobalMapLayer : CCLayer
{
    id<GlobalMapLayerDelegate> delegate;
    
    CCMenu *selectMapMenu;
//    CCMenuItem *backBtn;
    
    CCSprite *firs[kMaxFirs];
    BOOL isFirsShown;
}

- (id) initWithDelegate: (id<GlobalMapLayerDelegate>) delegate;
+ (id) globalMapLayerWithDelegate: (id<GlobalMapLayerDelegate>) delegate;

- (void) showMapPoints;
- (void) animateMapPoints;

- (void) showFirs;

@end
