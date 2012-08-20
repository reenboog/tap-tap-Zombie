//
//  CCPopupLayer.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCPopupLayerDelegate.h"


#define kPopupZOrder 1000000

@interface CCPopupLayer : CCLayer
{
    id<CCPopupLayerDelegate> delegate;
}

- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate;
+ (id) popupWithDelegate: (id<CCPopupLayerDelegate>) delegate;

+ (void) showOnRunningSceneWithDelegate: (id<CCPopupLayerDelegate>) delegate;

@end
