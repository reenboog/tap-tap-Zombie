//
//  CCNodeExtension.h
//  tapTapZombie
//
//  Created by Alexander on 16.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface CCNode(CCExtension)

- (void) pauseSchedulerAndActionsWithChildren;
- (void) resumeSchedulerAndActionsWithChildren;

- (void) disableWithChildren;
- (void) enableWithChildren;

- (void) removeFromParentWithCleanup;

- (BOOL) touchInNode: (UITouch *) touch;
- (BOOL) worldPointInNode: (CGPoint) worldPoint;

@end
