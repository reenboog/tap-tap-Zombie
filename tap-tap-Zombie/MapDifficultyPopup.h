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
    
    CCMenuItem *difficultyBtn[kMaxGameDifficulty + 1];
    CCMenuItem *closePopupBtn;
}

@property (nonatomic, readonly) id<MapDifficultyPopupDelegate> delegate;

- (id) initWithDelegate: (id<MapDifficultyPopupDelegate>) delegate;
+ (id) popupWithDelegate: (id<MapDifficultyPopupDelegate>) delegate;

@end
