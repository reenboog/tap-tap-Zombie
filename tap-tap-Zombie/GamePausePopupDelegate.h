//
//  GamePausePopupDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GamePausePopupDelegate <CCPopupLayerDelegate>

- (void) exit;
- (void) restart;

- (float) score;
- (float) bestScore;
- (int) zombiesLeft;

- (BOOL) isArcadeGame;

@end
