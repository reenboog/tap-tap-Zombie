//
//  GameItem.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


typedef enum 
{
    gis_none,
    gis_moving,
    gis_standing,
    gis_disappearing
} GameItemState;

@interface GameItem : CCNode
{
    CCSprite *sprite;
    
    GameItemState state;
}

- (id) initWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t;
+ (id) gameItemWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t;

- (void) tap: (UITouch *) touch;

- (void) stop;

@end
