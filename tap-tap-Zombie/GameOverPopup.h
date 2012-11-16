//
//  GameOverPopup.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameOverPopupDelegate.h"

@interface GameOverPopup : CCPopupLayer <CCPopupLayerDelegate>
{
    CCLayerColor *background;
    
    CCMenuItem *resetBtn;
    CCMenuItem *shopBtn;
    CCMenuItem *exitBtn;
    
    CCNode *time;
    CCNode *perfectTaps;
    CCNode *score;
    
    CCMenuItemLabel *resurrection;
    
    CCLabelBMFont *header;
}

@property (nonatomic, readonly) id<GameOverPopupDelegate> delegate;

- (id) initWithDelegate: (id<GameOverPopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<GameOverPopupDelegate>) delegate;

@end
