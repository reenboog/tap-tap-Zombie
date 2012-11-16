//
//  GameDifficultyPopup.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MapDifficultyPopupDelegate.h"


@interface MapDifficultyPopup : CCPopupLayer
{
    CCLayerColor *background;
    CCLabelBMFont *header;
    
    CCMenuItemLabel *difficultyBtn[kMaxGameDifficulty + 1];
    CCMenuItemLabel *closePopupBtn;
    CCMenuItemLabel *arcadeModeBtn;
}

@property (nonatomic, readonly) id<MapDifficultyPopupDelegate> delegate;

- (id) initWithDelegate: (id<MapDifficultyPopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<MapDifficultyPopupDelegate>) delegate;

@end
