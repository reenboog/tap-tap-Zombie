//
//  GameLayer.h
//  tapTapZombie
//
//  Created by Alexander on 17.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HUD.h"


@interface GameLayer : CCLayer
{
    CCLayer *gameItems;
}

- (void) reset;
- (void) pause;
- (void) resume;

- (void) runGameItemWithStartPosition: (CGPoint) sp endPosition: (CGPoint) ep time: (ccTime) t;

@end
