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
    
    CCMenuItem *restartBtn;
    CCMenuItem *exitBtn;
    
    CCMenuItem *closePopupBtn; 
}

@property (nonatomic, readonly) id<GamePausePopupDelegate> delegate;

- (id) initWithDelegate: (id<GamePausePopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<GamePausePopupDelegate>) delegate;

@end
