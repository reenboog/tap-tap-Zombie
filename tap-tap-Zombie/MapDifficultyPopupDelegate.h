//
//  GameDifficultyPopupDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"

#import <Foundation/Foundation.h>

@protocol MapDifficultyPopupDelegate <CCPopupLayerDelegate>

- (void) setMapDifficulty: (GameDifficulty) mapDifficulty;

@end
