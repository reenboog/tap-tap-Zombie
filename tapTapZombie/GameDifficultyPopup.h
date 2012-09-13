//
//  SelectGameDifficultyPopup.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"

#import "Game.h"


@interface GameDifficultyPopup : CCPopupLayer
{
    CCLayerColor *background;
    
    CCMenuItem *difficultyBtn[kMaxGameDifficulty + 1];
    CCMenuItem *closePopupBtn;
}

@end
