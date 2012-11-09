//
//  HUDLayerDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HUDLayerDelegate

- (void) pause;

@property (nonatomic, readonly) BOOL isArcadeGame;

- (void) bombAbility;
- (void) shieldAbility;
- (void) randomAbility;
- (void) timebBonusAbility;

@end
