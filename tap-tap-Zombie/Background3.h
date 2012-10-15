//
//  Background1.h
//  tapTapZombie
//
//  Created by Alexander on 29.09.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Background3 : CCLayer
{
    CCSprite *clouds;
}

- (id) initWithNumberOfTracks: (int) num;
+ (id) backgroundWithNumberOfTracks: (int) num;

@end
