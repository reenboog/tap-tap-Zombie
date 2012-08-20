//
//  SelectGameDifficultyPopup.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "Game.h"


@interface SelectGameDifficultyPopup : CCPopupLayer
{
    CCLayerColor *background;
    
    CCMenuItem *difficultyBtn[kGameMaxDifficulty + 1];
    CCMenuItem *closePopupBtn;
}

@end
