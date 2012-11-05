//
//  TutorialPopup.h
//  tap-tap-Zombie
//
//  Created by Alexander on 31.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface TutorialPopup : CCPopupLayer
{
    CCLayer *pagesLayer;
    
    CCLayerColor *background;
    
    CCMenuItemImage *rightBtn;
    CCMenuItemImage *leftBtn;
    CCMenuItem *skipBtn;
    
    int currentPageNumber;
}

- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate pages: (NSArray *) pages;
+ (id) popupWithDelegate: (id<CCPopupLayerDelegate>) delegate pages: (NSArray *) pages;

@end
