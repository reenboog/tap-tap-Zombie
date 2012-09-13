//
//  HUD.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "HUDDelegate.h"
#import "GameLayerHUDDelegate.h"


@interface HUD : CCLayer <CCPopupLayerDelegate, GameLayerHUDDelegate>
{
    id<HUDDelegate> delegate;
    
    CCMenuItem *pauseBtn;
    
    CCProgressTimer *progressScale;
    
    // additional
    CCLabelTTF *movingTimeLabel;
    CCLabelTTF *standingTimeLabel;
    CCLabelTTF *perfectWaysLabel;
}

@property (nonatomic, assign) id<HUDDelegate> delegate;

+ (id) hud;

@end
