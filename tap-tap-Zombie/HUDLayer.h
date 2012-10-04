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
}

- (id) initWithDelegate: (id<HUDLayerDelegate>) delegate;
+ (id) hudLayerWithDelegate: (id<HUDLayerDelegate>) delegate;

- (void) setProgressScaleValue: (float) value;

@end
