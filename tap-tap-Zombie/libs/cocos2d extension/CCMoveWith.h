//
//  CCMoveWith.h
//  tap-tap-Zombie
//
//  Created by Alexander on 04.10.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface CCMoveWith : CCActionInterval <NSCopying>
{
    NSArray *keyPoints;
}

- (id) initWithDuration: (ccTime) duration keyPoints: (NSArray *) keyPoints;
+ (id) actionWithDuration: (ccTime) duration keyPoints: (NSArray *) keyPoints;

@end
