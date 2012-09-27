//
//  GameLayerHUDDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HUDDelegate;

@protocol GameLayerHUDDelegate <NSObject>

- (void) setDelegate: (id<HUDDelegate>) delegate;

- (void) updateMovingTime: (float) t min: (float) mint max: (float) maxt;
- (void) updateStandingTime: (float) t min: (float) mint max: (float) maxt;
- (void) updatePerfectWays: (int) pw;

- (void) setValueForProgressScale: (float) value;

- (void) showGameOverPopup;

@end
