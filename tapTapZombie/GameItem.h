//
//  GameItem.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "LogicGameItemDelegate.h"
#import "GameItemLogicDelegate.h"


typedef enum 
{
    gis_none,
    gis_moving,
    gis_standing,
    gis_disappearing
} GameItemState;

@interface GameItem : CCNode <LogicGameItemDelegate>
{
    id<GameItemLogicDelegate> delegate;
    
    CCSprite *sprite;
    
    GameItemState state;
    
    BOOL isCatched;
    
    int wave;
    int index;
}

@property (nonatomic) int wave;
@property (nonatomic) int index;

- (id) initWithDelegate: (id<GameItemLogicDelegate>) delegate;
+ (id) gameItemWithDelegate: (id<GameItemLogicDelegate>) delegate;

- (void) runWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep movingTime: (ccTime) mt standingTime: (ccTime) st;

- (void) tap: (UITouch *) touch;

- (void) stop;

@end
