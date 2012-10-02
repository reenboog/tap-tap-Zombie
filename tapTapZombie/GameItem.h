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


@interface GameItem : CCNode <LogicGameItemDelegate>
{
    id<GameItemLogicDelegate> delegate;
    
    CCSprite *sprite;
    
    GameItemState state;
    
    BOOL isCatched;
    
    int wave;
    int index;
    
    NSArray *keyPoints;
    int nCurrentKeyPoint;
    
    float movingTime;
    float standingTime;
    
    float award;
}

@property (nonatomic) int wave;
@property (nonatomic) int index;
@property (nonatomic, readonly) GameItemState state;
@property (nonatomic, readonly) float award;

- (id) initWithDelegate: (id<GameItemLogicDelegate>) delegate;
+ (id) gameItemWithDelegate: (id<GameItemLogicDelegate>) delegate;

- (void) runWithKeyPoints: (NSArray *) keyPoints movingTime: (ccTime) mt standingTime: (ccTime) st;

- (void) tap: (UITouch *) touch;

- (void) stop;

@end
