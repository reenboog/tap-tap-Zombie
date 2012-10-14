//
//  Trap.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum 
{
    TrapStateNone,
    TrapStateNormal,
    TrapStateGreen,
    TrapStateRed
} TrapState;

@interface Trap : CCNode
{
    CCSprite *body;
    CCSprite *light;
    CCSprite *backLight;
    CCSprite *gate;
    
    TrapState state;
    
    BOOL isShieldModActivated;
    
    BOOL isTrapActivated;
}

+ (id) trap;

- (void) setState: (TrapState) state;

- (void) makeNormal;
- (void) makeGreen;
- (void) makeRed;

- (BOOL) tap: (UITouch *) touch;

- (void) activateShieldMod;
- (void) deactivateShieldMod;

- (void) activateTrap;

@end
