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

@interface GameOverPopup : CCPopupLayer
{
    CCLayerColor *background;
    
    CCMenuItem *resetBtn;
    CCMenuItem *exitBtn;
    
    CCLabelBMFont *statusLabel;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *perfectWavesLabel;
}

@property (nonatomic, readonly) id<GameOverPopupDelegate> delegate;

- (id) initWithDelegate: (id<GameOverPopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<GameOverPopupDelegate>) delegate;

@end
