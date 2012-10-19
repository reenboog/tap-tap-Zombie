//
//  GameOverPopupDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameOverPopupDelegate <CCPopupLayerDelegate>

- (void) restart;
- (void) exit;

@property (nonatomic, readonly) BOOL isGameFailed;
@property (nonatomic, readonly) float score;
@property (nonatomic, readonly) int totalPerfectWavesCounter;
@property (nonatomic, readonly) int totalFailedWavesCounter;
@property (nonatomic, readonly) int longestPerfectCycleLength;
@property (nonatomic, readonly) float timer;
@property (nonatomic, readonly) BOOL isArcadeGame;

@end
