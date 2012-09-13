//
//  GameLogicDelegate.h
//  tapTapZombie
//
//  Created by Alexander on 11.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Map.h"


@protocol LogicGameItemDelegate;

@protocol GameLogicDelegate <NSObject>

- (id<LogicGameItemDelegate>) runGameItemWithTrack: (Track) track movingTime: (float) mt standingTime: (float) st;

@end
