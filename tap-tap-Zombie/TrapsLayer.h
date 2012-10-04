//
//  TrapsLayer.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "TrapsLayerDelegate.h"

#import "Trap.h"


@interface TrapsLayer : CCLayer
{
    id<TrapsLayerDelegate> delegate;
}

- (id) initWithDelegate: (id<TrapsLayerDelegate>) delegate;
+ (id) trapsLayerWithDelegate: (id<TrapsLayerDelegate>) delegate;

- (void) setTrapState: (TrapState) state atIndex: (int) index;

@end
