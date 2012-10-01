//
//  Level00Background.h
//  tapTapZombie
//
//  Created by Alexander on 23.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Background0 : CCLayer
{
    CCSprite *clouds;
}

- (id) initWithNumberOfRoads: (int) num;
+ (id) backgroundWithNumberOfRoads: (int) num;

@end
