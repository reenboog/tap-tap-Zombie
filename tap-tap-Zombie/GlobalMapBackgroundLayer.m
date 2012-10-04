//
//  GlobalMapBackgroundLayer.m
//  tap-tap-Zombie
//
//  Created by Alexander on 03.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalMapBackgroundLayer.h"

#import "GameConfig.h"


@implementation GlobalMapBackgroundLayer

#pragma mark init and dealloc
- (id) init
{
    if(self = [super init])
    {
        CCSprite *backgroundSprite = [CCSprite spriteWithFile: @"globalMap/mapBackground.png"];
        backgroundSprite.position = kScreenCenter;
        [self addChild: backgroundSprite];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

@end
