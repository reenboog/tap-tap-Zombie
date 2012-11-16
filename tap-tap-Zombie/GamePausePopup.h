//
//  GamePausePopup.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GamePausePopupDelegate.h"


@interface GamePausePopup : CCPopupLayer
{
    CCLayerColor *background;
    CCLabelBMFont *header;
    
    CCMenuItem *restartBtn;
    CCMenuItem *exitBtn;
    
    CCMenuItem *closePopupBtn;
    
    CCNode *score;
    CCNode *bestScore;
    CCNode *zombiesLeft;
}

@property (nonatomic, readonly) id<GamePausePopupDelegate> delegate;

- (id) initWithDelegate: (id<GamePausePopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<GamePausePopupDelegate>) delegate;

@end
