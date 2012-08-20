//
//  CCPopupLayer.m
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCPopupLayer.h"


@implementation CCPopupLayer

#pragma mark init and dealloc
- (id) init
{
    assert(nil);
}

- (id) initWithDelegate: (id<CCPopupLayerDelegate>) delegate_
{
    if(self = [super init])
    {
        delegate = delegate_;
    }
    
    return self;
}

+ (id) popupWithDelegate: (id<CCPopupLayerDelegate>) delegate
{
    return [[self alloc] initWithDelegate: delegate];
}

+ (void) showOnRunningSceneWithDelegate: (id<CCPopupLayerDelegate>) delegate
{
    [[[CCDirector sharedDirector] runningScene] addChild: [self popupWithDelegate: delegate] z: kPopupZOrder];
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -

- (void) onEnter
{
    [delegate onPopupOpened];
    
    [super onEnter];
}

- (void) onExit
{
    [super onExit];
    
    [delegate onPopupClosed];
}

@end
