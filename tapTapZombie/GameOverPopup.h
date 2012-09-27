//
//  GameOverPopup.h
//  tapTapZombie
//
//  Created by Alexander on 27.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverPopup : CCPopupLayer
{
    CCLayerColor *background;
    
    CCMenuItem *resetBtn;
    CCMenuItem *exitBtn;
    
    CCLabelBMFont *statusLabel;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *perfectWavesLabel;
}

@end
