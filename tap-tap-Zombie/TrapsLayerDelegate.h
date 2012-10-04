//
//  TrapsLayerDelegate.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Map;

@protocol TrapsLayerDelegate

- (void) activatedTrapAtIndex: (int) index;

@property (nonatomic, readonly) Map *map;

@end
