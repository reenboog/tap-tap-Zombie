//
//  GameLayerDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameLayerDelegate

- (void) giveAward: (float) award;

- (void) increaseSuccess;
- (void) decreaseSuccess;

- (void) updateGameState;

- (void) perfectWave;
- (void) failedWave;

// for arcade game mode
- (void) addTimeBonus: (float) timeBonus;

@property (nonatomic, readonly) BOOL isArcadeGame;

@end
