//
//  GamePausePopup.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GamePausePopup : CCPopupLayer
{
    CCLayerColor *background;
    
    CCMenuItem *resetBtn;
    CCMenuItem *exitBtn;
    
    CCMenuItem *closePopupBtn; 
}

@end
