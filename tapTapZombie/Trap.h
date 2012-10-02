//
//  Trap.h
//  tapTapZombie
//
//  Created by Alexander on 02.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum 
{
    ts_none,
    ts_normal,
    ts_green,
    ts_red
} TrapStatus;

@interface Trap : CCNode
{
    CCSprite *body;
    CCSprite *light;
    
    TrapStatus status;
}

- (void) makeNormal;
- (void) makeGreen;
- (void) makeRed;

@end
