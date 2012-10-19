//
//  HUDLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "HUDLayerDelegate.h"


@interface HUDLayer : CCLayer
{
    id<HUDLayerDelegate> delegate;
    
    CCMenuItem *pauseBtn;
    CCProgressTimer *progressScale;
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *superModeLabel;
    
    CCLabelBMFont *timerLabel;
}

- (id) initWithDelegate: (id<HUDLayerDelegate>) delegate;
+ (id) hudLayerWithDelegate: (id<HUDLayerDelegate>) delegate;

- (void) setProgressScaleValue: (float) value;
- (void) setScoreValue: (float) value;

- (void) updateSuperModeLabelWithValue: (int) value;
- (void) showSuperModeLabel;
- (void) hideSuperModeLabel;

// for arcade game mode
- (void) setTimerValue: (float) timer;

@end
