//
//  CCNodeExtension.m
//  tapTapZombie
//
//  Created by Alexander on 16.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCNodeExtension.h"


@implementation CCNode(CCExtension)

#pragma mark pause/resume
- (void) pauseSchedulerAndActionsWithChildren
{
    [self pauseSchedulerAndActions];
    
    for(CCNode *child in [self children])
    {
        [child pauseSchedulerAndActionsWithChildren];
    }
}

- (void) resumeSchedulerAndActionsWithChildren
{
    [self resumeSchedulerAndActions];
    
    for(CCNode *child in [self children])
    {
        [child resumeSchedulerAndActionsWithChildren];
    }
}

#pragma mark enable/disable

- (void) disableWithChildren
{
    if([self isKindOfClass: [CCMenuItem class]])
    {
        [(CCMenuItem *)self setIsEnabled: NO];
    }
    
    if([self isKindOfClass: [CCLayer class]] && ![self isKindOfClass: [CCMenu class]])
    {
        [(CCLayer *)self setIsTouchEnabled: NO];
    }
    
    for(CCNode *child in [self children])
    {
        [child disableWithChildren];
    }
}

- (void) enableWithChildren
{
    if([self isKindOfClass: [CCMenuItem class]])
    {
        [(CCMenuItem *)self setIsEnabled: YES];
    }
    
    if([self isKindOfClass: [CCLayer class]] && ![self isKindOfClass: [CCMenu class]])
    {
        [(CCLayer *)self setIsTouchEnabled: YES];
    }
    
    for(CCNode *child in [self children])
    {
        [child enableWithChildren];
    }
}

#pragma mark removing from parent
- (void) removeFromParentWithCleanup
{
    [self removeFromParentAndCleanup: YES];
}

#pragma mark include point
- (BOOL) touchInNode: (UITouch *) touch
{
    CGPoint touchLoc = [touch locationInView: [touch view]];            // convert to "View coordinates" from "window" presumably
    touchLoc = [[CCDirector sharedDirector] convertToGL: touchLoc];     // move to "cocos2d World coordinates"
    
    return [self worldPointInNode: touchLoc];
}

- (BOOL) worldPointInNode: (CGPoint) worldPoint
{
    // scale the bounding rect of the node to world coordinates so we can see if the worldPoint is in the node.
//    CGRect bbox = CGRectMake( 0.0f, 0.0f, self.contentSize.width, self.contentSize.height );    // get bounding box in local 
//    bbox = CGRectApplyAffineTransform(bbox, [self nodeToWorldTransform] );      // convert box to world coordinates, scaling etc.
//    return CGRectContainsPoint( bbox, worldPoint );
    
    CGRect bbox = CGRectMake(0.0f, 0.0f, self.contentSize.width, self.contentSize.height);
    CGPoint p = [self convertToNodeSpaceAR: worldPoint];
    return CGRectContainsPoint(bbox, p);
}

@end
