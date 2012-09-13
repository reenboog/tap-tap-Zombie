//
//  CCPopupLayer.c
//  tapTapZombie
//
//  Created by Alexander on 10.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCPopupLayer.h"


@implementation CCPopupLayer

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
    return [[[self alloc] initWithDelegate: delegate] autorelease];
}

+ (void) showOnRunningSceneWithDelegate: (id<CCPopupLayerDelegate>) delegate
{
    [[[CCDirector sharedDirector] runningScene] addChild: [self popupWithDelegate: delegate] z: kPopupZOrder];
}

- (void) onEnter
{
    [super onEnter];
    
    [delegate popupWillOpen: self];
}

- (void) onExit
{
    [super onExit];
    
    [delegate popupDidFinishClosing: self];
}

@end